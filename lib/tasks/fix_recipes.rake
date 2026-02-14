namespace :recipes do
  desc "Fix recipes with JSON/Ruby hash-formatted instructions from Difford's Guide"
  task fix_json_instructions: :environment do
    puts 'Fixing recipes with structured instructions...'

    fixed_count = 0
    error_count = 0

    # Find recipes that contain HowToStep in their instructions or description
    Recipe.where("instructions LIKE '%HowToStep%' OR description LIKE '%HowToStep%'").find_each do |recipe|
      instructions_text = recipe.instructions
      description_text = recipe.description.to_s
      cleaned_instructions = nil
      cleaned_description = nil

      # Try to parse as Ruby hash array (it uses => instead of :)
      if instructions_text.include?('=>"') || instructions_text.include?("=>'\"")
        # It's Ruby hash syntax, use eval safely
        begin
          instructions_data = eval(instructions_text)

          if instructions_data.is_a?(Array)
            # Extract text from each step
            text_steps = instructions_data.map { |step| step['text'] || step[:text] }.compact
            cleaned_instructions = text_steps.join("\n\n")
          end
        rescue SyntaxError => e
          puts "  Ruby parse error for #{recipe.name} instructions: #{e.message}"
          error_count += 1
        end
      elsif instructions_text.include?('HowToStep')
        # Try JSON
        begin
          instructions_data = JSON.parse(instructions_text)

          if instructions_data.is_a?(Array)
            text_steps = instructions_data.map { |step| step['text'] }.compact
            cleaned_instructions = text_steps.join("\n\n")
          end
        rescue JSON::ParserError => e
          puts "  JSON parse error for #{recipe.name} instructions: #{e.message}"
          error_count += 1
        end
      end

      # Also fix description if it has JSON
      if description_text.include?('HowToStep')
        if description_text.include?('=>"') || description_text.include?("=>'\"")
          begin
            desc_data = eval(description_text)
            if desc_data.is_a?(Array)
              text_steps = desc_data.map { |step| step['text'] || step[:text] }.compact
              cleaned_description = text_steps.join("\n\n").first(200)
            end
          rescue SyntaxError => e
            puts "  Ruby parse error for #{recipe.name} description: #{e.message}"
          end
        else
          begin
            desc_data = JSON.parse(description_text)
            if desc_data.is_a?(Array)
              text_steps = desc_data.map { |step| step['text'] }.compact
              cleaned_description = text_steps.join("\n\n").first(200)
            end
          rescue JSON::ParserError => e
            puts "  JSON parse error for #{recipe.name} description: #{e.message}"
          end
        end
      end

      # Update if we have any changes
      if cleaned_instructions.present? || cleaned_description.present?
        update_attrs = {}
        update_attrs[:instructions] = cleaned_instructions if cleaned_instructions.present?
        update_attrs[:description] = cleaned_description if cleaned_description.present?

        recipe.update!(update_attrs)
        fixed_count += 1
        puts "  Fixed: #{recipe.name}"
      end
    rescue StandardError => e
      puts "  Error fixing #{recipe.name}: #{e.message}"
      error_count += 1
    end

    puts "\nDone!"
    puts "  Fixed: #{fixed_count}"
    puts "  Errors: #{error_count}"
  end
end
