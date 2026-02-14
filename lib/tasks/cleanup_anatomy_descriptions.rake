namespace :recipes do
  desc 'Clear descriptions from Anatomy of a Drink recipes that are just instructions'
  task cleanup_anatomy_descriptions: :environment do
    puts 'Cleaning up Anatomy of a Drink recipe descriptions...'

    cleared_count = 0

    Recipe.where("source_url LIKE '%danielzajic.com%'").find_each do |recipe|
      next if recipe.description.blank?

      # Check if description matches the start of instructions
      if recipe.instructions.present? && recipe.instructions.start_with?(recipe.description)
        recipe.update!(description: nil)
        cleared_count += 1
        puts "  Cleared: #{recipe.name}"
      end
    end

    puts "\nDone!"
    puts "  Cleared: #{cleared_count}"
  end
end
