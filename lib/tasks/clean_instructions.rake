require 'json'

namespace :recipes do
  desc 'Clean up JSON markup in recipe instructions'
  task clean_instructions: :environment do
    puts 'Cleaning up JSON markup in instructions...'

    cleaned_count = 0

    Recipe.where('instructions LIKE ?', '%@type%').find_each do |recipe|
      instructions = recipe.instructions

      begin
        # Try to parse the string as Ruby hash/array syntax
        # The data is stored as Ruby hash syntax (=>) not JSON
        data = eval(instructions)

        if data.is_a?(Array)
          steps = data.map do |step|
            if step.is_a?(Hash) && step['text']
              step['text']
            elsif step.is_a?(String)
              step
            else
              step.to_s
            end
          end

          clean_instructions = steps.join("\n\n")

          puts "Cleaning: #{recipe.name}"
          puts "  Steps: #{steps.count}"
          puts

          recipe.update!(instructions: clean_instructions)
          cleaned_count += 1
        end
      rescue SyntaxError, StandardError => e
        puts "Could not parse #{recipe.name}: #{e.message}"
      end
    end

    puts "Done! Cleaned #{cleaned_count} recipes."
  end
end
