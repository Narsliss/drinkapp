namespace :recipes do
  desc 'Clean up ingredient names by removing ALL measurements'
  task clean_ingredients: :environment do
    puts 'Cleaning up ingredient names...'

    cleaned_count = 0
    merged_count = 0

    Ingredient.find_each do |ingredient|
      name = ingredient.name
      original_name = name

      # Handle patterns like "½ Oz. / 15 Ml. " or "Oz. / 30 Ml. " or "¾ Oz. / 22.5 Ml. "
      # First remove the oz/ml part with fractions and decimals
      name = name.gsub(%r{^\s*(?:\d+[½¼¾⅓⅔]?|½|¼|¾)\s*oz\.?\s*/\s*\d+\.?\d*\s*ml\.?\s*}i, '')

      # Handle "Oz. / 60 Ml. " (no leading number)
      name = name.gsub(%r{^\s*oz\.?\s*/\s*\d+\.?\d*\s*ml\.?\s*}i, '')

      # Handle remaining ml. patterns like "15 Ml. " or "22.5 Ml. "
      name = name.gsub(/^\s*\d+\.?\d*\s*ml\.?\s*/i, '')

      # Handle other measurement patterns
      name = name.gsub(/^\s*\d+\s*(?:oz\.?|ml\.?|tsp\.?|tbsp\.?|dash|splash|drop|g\.?|gram)s?\s*/i, '')

      # Handle fractions alone
      name = name.gsub(/^[½¼¾⅓⅔]\s*/, '')

      # Handle just numbers at start
      name = name.gsub(/^\s*\d+(?:\.\d+)?\s*/, '')

      # Clean up leftover punctuation and whitespace
      name = name.gsub(%r{^[\s,\-./]+}, '')
      name = name.gsub(/\s+/, ' ')
      name = name.strip

      # Skip if no change or empty
      next if name == original_name || name.blank?

      puts "Cleaning '#{original_name}'"
      puts "  -> '#{name}'"

      # Check if ingredient with cleaned name already exists (case insensitive)
      existing = Ingredient.where('LOWER(TRIM(name)) = ?', name.downcase).where.not(id: ingredient.id).first

      if existing
        # Merge this ingredient into the existing one
        puts "  -> Merging into existing: '#{existing.name}'"

        # Update all recipe_ingredients to use the existing ingredient
        RecipeIngredient.where(ingredient: ingredient).update_all(ingredient_id: existing.id)

        # Delete the duplicate
        ingredient.destroy
        merged_count += 1
      else
        # Just update the name
        ingredient.update!(name: name)
        cleaned_count += 1
      end
    end

    puts "\nDone!"
    puts "Cleaned: #{cleaned_count} ingredients"
    puts "Merged: #{merged_count} duplicates"
    puts "Total ingredients now: #{Ingredient.count}"
  end
end
