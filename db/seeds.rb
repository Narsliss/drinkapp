# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts 'Creating sample recipes...'

# Sample recipes data
recipes_data = [
  {
    name: 'Classic Margarita',
    description: 'A refreshing Mexican cocktail made with tequila, lime juice, and triple sec.',
    instructions: "1. Rub the rim of a chilled cocktail glass with a lime wedge and dip in salt.
2. In a shaker, combine tequila, lime juice, and triple sec with ice.
3. Shake vigorously for 10-15 seconds.
4. Strain into the prepared glass.
5. Garnish with a lime wheel.",
    glass: 'Cocktail glass',
    ingredients: [
      { name: 'Tequila', amount: '2 oz' },
      { name: 'Lime juice', amount: '1 oz' },
      { name: 'Triple sec', amount: '1 oz' },
      { name: 'Salt', amount: 'for rim' },
      { name: 'Lime', amount: 'for garnish' }
    ]
  },
  {
    name: 'Mojito',
    description: 'A Cuban highball with white rum, lime, mint, sugar, and soda water.',
    instructions: "1. Muddle mint leaves with sugar and lime juice in a highball glass.
2. Add a splash of soda water and fill the glass with cracked ice.
3. Pour the rum and top with soda water.
4. Garnish with a sprig of mint and lime slice.",
    glass: 'Highball glass',
    ingredients: [
      { name: 'White rum', amount: '2 oz' },
      { name: 'Lime juice', amount: '1 oz' },
      { name: 'Mint leaves', amount: '6-8 leaves' },
      { name: 'Sugar', amount: '2 tsp' },
      { name: 'Soda water', amount: 'to top' }
    ]
  },
  {
    name: 'Old Fashioned',
    description: 'A classic cocktail made with whiskey, sugar, bitters, and citrus rind.',
    instructions: "1. Place sugar cube in an old fashioned glass and saturate with bitters.
2. Add a dash of plain water and muddle until dissolved.
3. Fill the glass with ice cubes and add whiskey.
4. Garnish with orange twist and a cocktail cherry.",
    glass: 'Old fashioned glass',
    ingredients: [
      { name: 'Bourbon or rye whiskey', amount: '2 oz' },
      { name: 'Sugar cube', amount: '1' },
      { name: 'Angostura bitters', amount: '2 dashes' },
      { name: 'Orange peel', amount: 'for garnish' },
      { name: 'Cocktail cherry', amount: 'optional' }
    ]
  },
  {
    name: 'Cosmopolitan',
    description: 'A stylish cocktail made with vodka, triple sec, cranberry juice, and lime.',
    instructions: "1. Shake vodka, triple sec, cranberry juice, and lime juice with ice.
2. Strain into a chilled cocktail glass.
3. Garnish with a lime wheel.",
    glass: 'Cocktail glass',
    ingredients: [
      { name: 'Vodka', amount: '1.5 oz' },
      { name: 'Triple sec', amount: '0.5 oz' },
      { name: 'Cranberry juice', amount: '1 oz' },
      { name: 'Lime juice', amount: '0.5 oz' },
      { name: 'Lime', amount: 'for garnish' }
    ]
  },
  {
    name: 'Negroni',
    description: 'An Italian cocktail made with equal parts gin, vermouth rosso, and Campari.',
    instructions: "1. Pour gin, vermouth, and Campari into a mixing glass with ice.
2. Stir well until chilled.
3. Strain into an old fashioned glass over fresh ice.
4. Garnish with an orange peel.",
    glass: 'Old fashioned glass',
    ingredients: [
      { name: 'Gin', amount: '1 oz' },
      { name: 'Sweet vermouth', amount: '1 oz' },
      { name: 'Campari', amount: '1 oz' },
      { name: 'Orange peel', amount: 'for garnish' }
    ]
  },
  {
    name: 'Whiskey Sour',
    description: 'A classic cocktail combining whiskey, lemon juice, and sugar.',
    instructions: "1. Shake whiskey, lemon juice, and simple syrup with ice.
2. Strain into a sour glass or old fashioned glass over ice.
3. Garnish with a cherry and orange slice.",
    glass: 'Sour glass',
    ingredients: [
      { name: 'Bourbon', amount: '2 oz' },
      { name: 'Lemon juice', amount: '0.75 oz' },
      { name: 'Simple syrup', amount: '0.5 oz' },
      { name: 'Cocktail cherry', amount: 'for garnish' },
      { name: 'Orange slice', amount: 'for garnish' }
    ]
  },
  {
    name: 'Daiquiri',
    description: 'A refreshing rum cocktail with lime juice and simple syrup.',
    instructions: "1. Shake rum, lime juice, and simple syrup with ice.
2. Strain into a chilled cocktail glass.
3. Serve straight up.",
    glass: 'Cocktail glass',
    ingredients: [
      { name: 'White rum', amount: '2 oz' },
      { name: 'Lime juice', amount: '1 oz' },
      { name: 'Simple syrup', amount: '0.75 oz' }
    ]
  },
  {
    name: 'Martini',
    description: 'The classic cocktail made with gin and dry vermouth.',
    instructions: "1. Pour gin and vermouth into a mixing glass with ice.
2. Stir well until very cold.
3. Strain into a chilled martini glass.
4. Garnish with olives or a lemon twist.",
    glass: 'Martini glass',
    ingredients: [
      { name: 'Gin', amount: '2.5 oz' },
      { name: 'Dry vermouth', amount: '0.5 oz' },
      { name: 'Olives', amount: 'for garnish' },
      { name: 'Lemon twist', amount: 'optional' }
    ]
  }
]

# Create recipes and their ingredients
recipes_data.each do |recipe_data|
  ingredients_data = recipe_data.delete(:ingredients)

  recipe = Recipe.find_or_create_by!(name: recipe_data[:name]) do |r|
    r.assign_attributes(recipe_data)
  end

  ingredients_data.each do |ingredient_data|
    ingredient = Ingredient.find_or_create_by!(name: ingredient_data[:name])

    RecipeIngredient.find_or_create_by!(recipe: recipe, ingredient: ingredient) do |ri|
      ri.amount = ingredient_data[:amount]
    end
  end

  puts "Created/Updated: #{recipe.name}"
end

puts "\nSeed complete! Created #{Recipe.count} recipes with #{Ingredient.count} ingredients."
