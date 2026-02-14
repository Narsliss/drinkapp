namespace :recipes do
  desc 'Scrape recipes from all cocktail websites'
  task scrape: :environment do
    puts 'Starting recipe scraping from all sources...'
    puts "Current recipe count: #{Recipe.count}"
    puts

    RecipeScraper.scrape_thecocktaildb
    RecipeScraper.scrape_cocktailvirgin
    RecipeScraper.scrape_diffords
    RecipeScraper.scrape_danielzajic

    puts
    puts 'Scraping complete!'
    puts "Total recipes: #{Recipe.count}"
    puts "Total ingredients: #{Ingredient.count}"
  end

  desc 'Scrape recipes from CocktailVirgin blog'
  task scrape_cocktailvirgin: :environment do
    puts 'Scraping CocktailVirgin...'
    puts "Current recipe count: #{Recipe.count}"

    RecipeScraper.scrape_cocktailvirgin

    puts
    puts 'Done!'
    puts "Total recipes: #{Recipe.count}"
  end

  desc 'Scrape recipes from Diffords Guide'
  task scrape_diffords: :environment do
    puts 'Scraping Diffords Guide...'
    puts "Current recipe count: #{Recipe.count}"

    RecipeScraper.scrape_diffords

    puts
    puts 'Done!'
    puts "Total recipes: #{Recipe.count}"
  end

  desc 'Scrape recipes from Daniel Zajic'
  task scrape_danielzajic: :environment do
    puts 'Scraping Daniel Zajic...'
    puts "Current recipe count: #{Recipe.count}"

    RecipeScraper.scrape_danielzajic

    puts
    puts 'Done!'
    puts "Total recipes: #{Recipe.count}"
  end

  desc 'Scrape recipes from TheCocktailDB API'
  task scrape_thecocktaildb: :environment do
    puts 'Scraping TheCocktailDB...'
    puts "Current recipe count: #{Recipe.count}"

    RecipeScraper.scrape_thecocktaildb

    puts
    puts 'Done!'
    puts "Total recipes: #{Recipe.count}"
  end
end
