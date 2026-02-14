module RecipesHelper
  def recipe_source_name(recipe)
    return 'DrinkApp' if recipe.source_url.blank?

    case recipe.source_url
    when /cocktailvirgin/
      'Cocktail Virgin'
    when /diffordsguide/
      "Difford's Guide"
    when /danielzajic/
      'Anatomy of a Drink'
    when /^\d+$/
      'TheCocktailDB'
    else
      'External Source'
    end
  end

  def recipe_source_url(recipe)
    return nil if recipe.source_url.blank?

    case recipe.source_url
    when /^http/
      recipe.source_url
    when /^\d+$/
      'https://www.thecocktaildb.com'
    end
  end

  def convert_measurement(amount_str)
    return amount_str if amount_str.blank?

    # Extract the numeric value and unit
    match = amount_str.match(%r{^(\d+\.?\d*|\d+/\d+|\d+\s+\d+/\d+)\s*(oz\.?|ounce|ounces|ml|dash|dashes|splash|splashes|tsp|tbsp|drop|drops|barspoon|part|parts|bsp|mls?|milliliters?)?$}i)

    return amount_str unless match

    value_str = match[1]
    unit = match[2]&.downcase

    # Parse the value
    value = parse_fraction(value_str)
    return amount_str unless value

    # Convert between oz and ml
    case unit
    when /^(oz\.?|ounce|ounces)$/
      ml_value = (value * 29.5735).round
      "#{amount_str} (#{ml_value} ml)"
    when /^(ml|mls?|milliliters?)$/
      oz_value = (value / 29.5735).round(2)
      # Clean up the oz value
      oz_display = oz_value == oz_value.to_i ? oz_value.to_i : oz_value
      "#{amount_str} (#{oz_display} oz)"
    else
      # For units like dash, splash, etc., just return as-is
      amount_str
    end
  end

  private

  def parse_fraction(str)
    str = str.strip

    # Handle mixed numbers like "1 1/2"
    if str.match(%r{^(\d+)\s+(\d+)/(\d+)$})
      whole = ::Regexp.last_match(1).to_i
      num = ::Regexp.last_match(2).to_i
      denom = ::Regexp.last_match(3).to_i
      return whole + (num.to_f / denom)
    end

    # Handle simple fractions like "1/2"
    if str.match(%r{^(\d+)/(\d+)$})
      num = ::Regexp.last_match(1).to_i
      denom = ::Regexp.last_match(2).to_i
      return num.to_f / denom
    end

    # Handle decimals
    str.to_f
  end
end
