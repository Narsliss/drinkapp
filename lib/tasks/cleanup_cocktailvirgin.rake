namespace :recipes do
  desc 'Clean up CocktailVirgin blog recipes that have story content mixed with instructions'
  task cleanup_cocktailvirgin: :environment do
    puts 'Cleaning up CocktailVirgin recipes...'

    cleaned_count = 0
    skipped_count = 0

    Recipe.where("source_url LIKE '%cocktailvirgin.blogspot.com%'").find_each do |recipe|
      instructions = recipe.instructions.to_s

      # Skip if already cleaned (short instructions, no story)
      if instructions.length < 300 && !instructions.include?('ago,') && !instructions.include?('I ventured')
        skipped_count += 1
        next
      end

      # Try to extract just the recipe instructions from the blog post
      lines = instructions.split("\n")

      # Find where ingredients end and instructions begin
      # Usually there's a blank line then a short instruction paragraph
      instruction_lines = []
      found_ingredients = false
      found_instructions = false

      lines.each_with_index do |line, _index|
        line = line.strip

        # Skip empty lines
        next if line.empty?

        # Check if this looks like an ingredient line
        is_ingredient = line.match?(/\d+.*(?:oz|ounce|ml|dash|splash|tsp|tbsp|part|drop)/i) && line.length < 100

        if is_ingredient
          found_ingredients = true
          next
        end

        # After ingredients, look for instruction line (usually starts with action verb)
        if found_ingredients && !found_instructions
          # Check if this looks like an instruction (starts with action verb or contains cocktail-making terms)
          is_instruction = line.match?(/^(Stir|Shake|Build|Combine|Pour|Add|Muddle|Strain|Garnish|Serve|Top|Fill)/i) ||
                           line.match?(/(?:stir|shake|strain|pour|glass|ice)/i)

          if is_instruction && line.length < 200
            instruction_lines << line
            found_instructions = true
          end
        elsif found_instructions
          # Stop if we hit a long paragraph (story/tasting notes)
          break if line.length > 150 || line.match?(/(ago,|I |We | tasted|flavor|aroma|story)/i)

          instruction_lines << line if line.length < 200
        end
      end

      if instruction_lines.any?
        cleaned_instructions = instruction_lines.join("\n")

        # Clear description if it looks like it contains ingredients
        description = recipe.description
        description = nil if description && description.match?(/\d+.*(?:oz|ounce|ml)/i)

        recipe.update!(
          instructions: cleaned_instructions,
          description: description
        )

        cleaned_count += 1
        puts "  Cleaned: #{recipe.name}"
      else
        skipped_count += 1
      end
    rescue StandardError => e
      puts "  Error cleaning #{recipe.name}: #{e.message}"
      skipped_count += 1
    end

    puts "\nDone!"
    puts "  Cleaned: #{cleaned_count}"
    puts "  Skipped: #{skipped_count}"
  end
end
