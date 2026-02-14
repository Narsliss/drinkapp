namespace :recipes do
  desc 'Clear descriptions that are just instruction snippets'
  task clear_bad_descriptions: :environment do
    puts 'Clearing descriptions that are instruction snippets...'

    cleared_count = 0

    # Find Difford's recipes where description matches the start of instructions
    Recipe.where("source_url LIKE '%diffordsguide.com%'").find_each do |recipe|
      next if recipe.description.blank? || recipe.instructions.blank?

      # Check if description is just the first part of instructions
      if recipe.instructions.start_with?(recipe.description) || recipe.description.start_with?(recipe.instructions.split("\n").first.to_s[0..100])
        recipe.update!(description: nil)
        cleared_count += 1
        puts "  Cleared: #{recipe.name}"
      end
    end

    puts "\nDone!"
    puts "  Cleared: #{cleared_count}"
  end
end
