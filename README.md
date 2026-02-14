# DrinkApp

A Rails application for discovering, filtering, and rating cocktail recipes.

## Features

- **Recipe Browser**: Browse cocktail recipes with beautiful cards
- **Ingredient Filtering**: Select multiple ingredients to find recipes that use all of them
- **Rating System**: Rate recipes from 1-5 stars
- **Personal Notes**: Add and edit notes for each recipe
- **Web Scraping**: Automatically import recipes from cocktail websites

## Getting Started

### Prerequisites

- Ruby 3.3.6 or higher
- Rails 7.1.6 or higher
- SQLite3

### Installation

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   ```

3. Start the server:
   ```bash
   bin/dev
   ```

4. Visit `http://localhost:3000` in your browser

## Usage

### Filtering Recipes

1. On the home page, check ingredients in the left sidebar
2. Click "Filter Recipes" to show only recipes containing all selected ingredients
3. Click "Clear Filters" to see all recipes again

### Rating Recipes

1. Click on any recipe to view its details
2. Select a star rating (1-5) at the bottom of the page
3. Click "Rate" to save your rating

### Adding Notes

1. View a recipe's details page
2. Scroll to the "Notes" section
3. Add or update your personal notes about the recipe

### Scraping Recipes

To import recipes from TheCocktailDB API:

```bash
rake recipes:scrape
```

This will fetch recipes for popular cocktails like Margarita, Mojito, Old Fashioned, etc.

## Database Schema

- **Recipe**: Stores cocktail recipes with name, description, instructions, image, and glass type
- **Ingredient**: Stores ingredients used across all recipes
- **RecipeIngredient**: Join table linking recipes to ingredients with amounts
- **Rating**: User ratings for recipes (1-5 stars)
- **Note**: Personal notes for recipes

## Technologies Used

- **Ruby on Rails**: Web framework
- **SQLite**: Database
- **Tailwind CSS**: Styling
- **Nokogiri**: HTML parsing for web scraping
- **HTTParty**: HTTP requests for API integration

## Customization

To add more websites to scrape, extend the `RecipeScraper` service in `app/services/recipe_scraper.rb`.
