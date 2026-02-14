class RecipesController < ApplicationController
  def index
    @ingredients = Ingredient.order(:name)
    @categories = IngredientCategory.order(:name).includes(:ingredients)

    # Define available sources for filter dropdown
    @sources = [
      ['Cocktail Virgin', 'cocktailvirgin'],
      ["Difford's Guide", 'diffordsguide'],
      ['Anatomy of a Drink', 'danielzajic'],
      ['TheCocktailDB', 'thecocktaildb']
    ]

    @recipes = Recipe.all

    # Filter by search term (case-insensitive for SQLite)
    @recipes = @recipes.where('LOWER(name) LIKE ?', "%#{params[:search].downcase}%") if params[:search].present?

    # Filter by source
    if params[:source].present?
      @recipes = case params[:source]
                 when 'thecocktaildb'
                   @recipes.where("CAST(source_url AS INTEGER) > 0 AND source_url NOT LIKE '%.%'")
                 else
                   @recipes.where('source_url LIKE ?', "%#{params[:source]}%")
                 end
    end

    # Filter by minimum rating
    if params[:min_rating].present?
      min_rating = params[:min_rating].to_f
      # Get recipe IDs that have average rating >= min_rating
      rated_recipe_ids = Recipe.joins(:ratings)
                               .group('recipes.id')
                               .having('AVG(ratings.score) >= ?', min_rating)
                               .pluck(:id)
      @recipes = @recipes.where(id: rated_recipe_ids)
    end

    # Filter by categories (ALL match - AND logic)
    # Recipe must have ingredients from ALL selected categories
    if params[:category_ids].present?
      category_ids = params[:category_ids].map(&:to_i)
      @recipes = @recipes.joins(:ingredients)
                         .where(ingredients: { category_id: category_ids })
                         .group('recipes.id')
                         .having('COUNT(DISTINCT ingredients.category_id) = ?', category_ids.length)
    elsif params[:ingredient_ids].present?
      # Fallback to old ingredient filter (AND logic)
      ingredient_ids = params[:ingredient_ids].map(&:to_i)
      @recipes = @recipes.joins(:ingredients)
                         .where(ingredients: { id: ingredient_ids })
                         .group('recipes.id')
                         .having('COUNT(DISTINCT ingredients.id) = ?', ingredient_ids.length)
    end

    @recipes = @recipes.includes(:ingredients, :ratings, :note).order(:name)

    # Group categories for the filter UI (do this before potential early return)
    @grouped_categories = @categories.group_by do |cat|
      case cat.name
      when /Rum|Vodka|Gin|Whiskey|Brandy|Agave/i
        'Base Spirits'
      when /Bitters/i
        'Bitters'
      when /Liqueur/i
        'Liqueurs'
      when /Vermouth/i
        'Vermouth'
      when /Amaro/i
        'Amaro'
      when /Juice|Soda|Syrup|Mixer|Water/i
        'Mixers'
      when /Cream|Dairy|Egg/i
        'Cream & Eggs'
      when /Fruit|Herb|Spice|Garnish/i
        'Fresh Ingredients'
      when /Wine|Beer/i
        'Wine & Beer'
      else
        'Other'
      end
    end.sort.to_h

    # If we used GROUP BY, we need to reset the query or use a subquery for counting
    # We'll get the IDs first, then fetch the records
    return unless @recipes.to_sql.include?('GROUP BY')

    recipe_ids = @recipes.pluck(:id)
    @recipes = Recipe.where(id: recipe_ids).includes(:ingredients, :ratings, :note).order(:name)
  end

  def show
    @recipe = Recipe.includes(:ingredients, :ratings, :note).find(params[:id])
    @rating = @recipe.ratings.build
    @note = @recipe.note || @recipe.build_note
  end
end
