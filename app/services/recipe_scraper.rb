require 'nokogiri'
require 'httparty'
require 'json'

class RecipeScraper
  # Helper method to find or create ingredients case-insensitively
  def self.find_or_create_ingredient(name)
    ingredient = Ingredient.where('LOWER(name) = LOWER(?)', name).first
    ingredient ||= Ingredient.create!(name: name)
    ingredient
  end

  def self.scrape_thecocktaildb
    puts "\n" + '=' * 50
    puts 'Scraping TheCocktailDB API...'
    puts '=' * 50

    api_url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s='

    popular_cocktails = [
      'margarita', 'mojito', 'old fashioned', 'martini', 'manhattan',
      'negroni', 'whiskey sour', 'daiquiri', 'mai tai', 'cosmopolitan',
      'bloody mary', 'moscow mule', 'gin and tonic', 'pina colada', 'long island',
      'tequila sunrise', 'bellini', 'mimosa', 'sazerac', 'sidecar',
      'french 75', 'tom collins', 'aviation', 'last word', 'paper plane',
      'penicillin', 'boulevardier', 'vieux carre', 'corpse reviver', 'vesper',
      'gimlet', 'fizz', 'collins', 'sour', 'flip', 'toddy', 'punch',
      'spritz', 'rickey', 'smash', 'buck', 'sling', 'cobbler', 'julep',
      'alexander', 'grasshopper', 'golden dream', 'stinger', 'velvet hammer',
      'white russian', 'black russian', 'espresso martini', 'irish coffee',
      'hot toddy', 'mulled wine', 'sangria', 'mimosa', 'bellini', 'kir royale',
      'champagne cocktail', 'french 75', 'mojito', 'caipirinha', 'pisco sour',
      'dark and stormy', 'hurricane', 'zombie', 'navy grog', 'jet pilot',
      'scorpion', 'tiki', 'blue hawaii', 'lava flow', 'painkiller',
      'barracuda', 'jungle bird', 'singapore sling', 'ramos gin fizz',
      'clover club', 'brooklyn', 'bijou', 'hanky panky', 'paloma',
      'tommy margarita', 'cadillac margarita', 'frozen margarita',
      'watermelon margarita', 'strawberry margarita', 'mango margarita',
      'classic martini', 'dry martini', 'perfect martini', 'wet martini',
      'dirty martini', 'vodka martini', 'appletini', 'chocolate martini',
      'espresso martini', 'pornstar martini', 'lychee martini',
      'manhattan', 'perfect manhattan', 'dry manhattan', 'sweet manhattan',
      'rob roy', 'bobby burns', 'rusty nail', 'godfather', 'godmother',
      'mexican firing squad', 'el diablo', 'paloma', 'tequila sunrise',
      'tequila sunset', 'bloody maria', 'margarita', 'tommys margarita',
      'mezcal margarita', 'smoky margarita', 'spicy margarita',
      'gin fizz', 'ramos gin fizz', 'sloe gin fizz', 'silver fizz',
      'royal gin fizz', 'diamond fizz', 'green fizz', 'purple fizz',
      'tom collins', 'john collins', 'vodka collins', 'whiskey collins',
      'brandy collins', 'rum collins', 'tequila collins',
      'whiskey sour', 'amaretto sour', 'pisco sour', 'new york sour',
      'boston sour', 'ward eight', 'french connection',
      'sidecar', 'between the sheets', 'corpse reviver 2', 'corpse reviver 1',
      'monkey gland', 'blood and sand', 'rusty nail', 'godfather',
      'vieux carre', 'sazerac', 'vieux carre', 'improved whiskey cocktail',
      'old fashioned', 'classic old fashioned', 'rye old fashioned',
      'brandy old fashioned', 'rum old fashioned', 'tequila old fashioned',
      'negroni', 'white negroni', 'sbagliato', 'boulevardier',
      'old pal', 'american', 'palmetto', 'fancy free',
      'daiquiri', 'classic daiquiri', 'frozen daiquiri', 'strawberry daiquiri',
      'banana daiquiri', 'hemingway daiquiri', 'papas special daiquiri',
      'mojito', 'classic mojito', 'frozen mojito', 'strawberry mojito',
      'mango mojito', 'pineapple mojito', 'coconut mojito',
      'martini', 'classic martini', 'dry martini', 'wet martini',
      'dirty martini', 'vodka martini', 'gibson', 'gimlet',
      'last word', 'final ward', 'paper plane', 'penicillin',
      'gold rush', 'brown derby', 'trinidad sour', 'naked and famous',
      'jungle bird', 'saturn', 'missionarys downfall', 'test pilot',
      'zombie', 'jet pilot', 'navy grog', 'three dots and a dash',
      'mai tai', 'classic mai tai', 'royal hawaiian mai tai',
      'pina colada', 'chi chi', 'lava flow', 'blue hawaii',
      'scorpion bowl', 'tiki bowl', 'volcano bowl', 'zombie',
      'painkiller', 'barracuda', 'singapore sling', 'royal hawaiian',
      'planters punch', 'hurricane', 'rum runner', 'miami vice',
      'margarita', 'tommys margarita', 'cadillac margarita',
      'frozen margarita', 'watermelon margarita', 'spicy margarita',
      'paloma', 'el diablo', 'tequila sunrise', 'bloody maria',
      'tequila sour', 'oaxaca old fashioned', 'mezcal negroni',
      'mezcal margarita', 'smoke show', 'division bell',
      'campari', 'aperol', 'cynar', 'fernet', 'amaro',
      'spritz', 'aperol spritz', 'campari spritz', 'cynar spritz',
      'negroni sbagliato', 'americano', 'martinez', 'turin',
      'manhattan', 'rob roy', 'perfect manhattan', 'dry manhattan',
      'brooklyn', 'new york', 'red hook', 'little italy',
      'boulevardier', 'old pal', 'right hand', 'left hand',
      'final ward', 'paper plane', 'penicillin', 'gold rush',
      'last word', 'chrysanthemum', 'bijou', 'hanky panky',
      'astoria', 'astor', 'rose', 'thistle', 'hudson',
      'cobble hill', 'greenpoint', 'star', 'slope',
      'remember the maine', 'monte carlo', 'fancy free',
      'frisco', 'fanciulli', 'ferrari', 'garibaldi',
      'americano', 'milano torino', 'negroni', 'sbagliato',
      'boulevardier', 'old pal', 'trident', 'tuxedo',
      'martinez', 'manhattan', 'brooklyn', 'red hook',
      'little italy', 'greenpoint', 'cobble hill',
      'sazerac', 'vieux carre', 'improved whiskey cocktail',
      'old fashioned', 'whiskey sour', 'new york sour',
      'fitzgerald', 'presbyterian', 'manhattan transfer',
      'french connection', 'godfather', 'rusty nail',
      'blood and sand', 'mamie taylor', 'ward eight',
      'boston sour', 'whiskey smash', 'mint julep',
      'hot toddy', 'irish coffee', 'cafe brulot', 'tom and jerry',
      'bishop', 'brandy alexander', 'brandy crusta', 'sidecar',
      'between the sheets', 'stinger', 'vieux carre',
      'corpse reviver 2', 'corpse reviver 1', 'monkey gland',
      'bees knees', 'gold rush', 'brown derby', 'honey bee',
      'airmail', 'daiquiri', 'hemingway daiquiri', 'el presidente',
      'mojito', 'cuba libre', 'papa doble', 'montego bay',
      'honey bee', 'bee sting', 'beekeeper', 'queen bee',
      'jack rose', 'ward eight', 'fish house punch',
      'philadelphia fish house punch', 'clover club',
      'ramos gin fizz', 'ramos fizz', 'silver fizz',
      'royal fizz', 'diamond fizz', 'sloe gin fizz',
      'tom collins', 'john collins', 'gin buck', 'gin fizz',
      'rickey', 'gin rickey', 'vodka rickey', 'rum rickey',
      'whiskey rickey', 'gin buck', 'mule', 'moscow mule',
      'kentucky mule', 'london mule', 'mexican mule', 'irish mule'
    ].uniq

    puts "Searching for #{popular_cocktails.count} cocktails..."

    created_count = 0
    errors_count = 0

    popular_cocktails.each_with_index do |cocktail, index|
      response = HTTParty.get("#{api_url}#{URI.encode_www_form_component(cocktail)}", timeout: 10)

      if response.success? && response['drinks']
        response['drinks'].each do |drink|
          created_count += 1 if create_recipe_from_api(drink)
        rescue StandardError => e
          puts "  Error creating recipe #{drink['strDrink']}: #{e.message}"
          errors_count += 1
        end
      end

      if (index + 1) % 10 == 0
        puts "  Progress: #{index + 1}/#{popular_cocktails.count} - #{cocktail} (#{created_count} created)"
      end

      sleep(0.3)
    rescue StandardError => e
      puts "  Error fetching #{cocktail}: #{e.message}"
      errors_count += 1
      sleep(0.5)
    end

    puts "\nTheCocktailDB Results:"
    puts "  Created: #{created_count}"
    puts "  Errors: #{errors_count}"
    puts "  Total recipes now: #{Recipe.count}"
  end

  def self.create_recipe_from_api(drink)
    return false if Recipe.exists?(source_url: drink['idDrink'])

    recipe = Recipe.create!(
      name: drink['strDrink'],
      description: drink['strInstructions']&.first(200),
      instructions: drink['strInstructions'],
      image_url: drink['strDrinkThumb'],
      source_url: drink['idDrink'],
      glass: drink['strGlass']
    )

    (1..15).each do |i|
      ingredient_name = drink["strIngredient#{i}"]
      measure = drink["strMeasure#{i}"]

      next if ingredient_name.blank?

      ingredient = find_or_create_ingredient(ingredient_name.strip.titleize)

      recipe.recipe_ingredients.create!(
        ingredient: ingredient,
        amount: measure&.strip
      )
    end

    puts "  + #{recipe.name}"
    true
  rescue StandardError => e
    puts "  Error creating recipe #{drink['strDrink']}: #{e.message}"
    false
  end

  # Scrape cocktailvirgin.blogspot.com
  def self.scrape_cocktailvirgin
    puts "\n" + '=' * 50
    puts 'Scraping CocktailVirgin...'
    puts '=' * 50

    # Generate archive URLs for years 2009-2025
    years = (2009..2025).to_a.reverse

    archive_urls = [
      'https://cocktailvirgin.blogspot.com/',
      'https://cocktailvirgin.blogspot.com/search?max-results=500'
    ]

    years.each do |year|
      archive_urls << "https://cocktailvirgin.blogspot.com/#{year}/"
    end

    puts "Will check #{archive_urls.count} archive pages"

    all_links = []
    errors = 0

    archive_urls.each_with_index do |url, index|
      begin
        puts "  [#{index + 1}/#{archive_urls.count}] Checking #{url}..."
        response = HTTParty.get(url, headers: { 'User-Agent' => 'Mozilla/5.0' }, timeout: 10)

        if response.success?
          doc = Nokogiri::HTML(response.body)
          links = doc.css('h3.post-title a, h2.post-title a, .post h3 a, .post h2 a, article h3 a, article h2 a').map do |a|
            a['href']
          end.compact.uniq
          all_links.concat(links)
          puts "    Found #{links.count} links from #{url}"
        else
          puts "    Failed: #{response.code}"
        end
      rescue StandardError => e
        puts "    Error: #{e.message}"
        errors += 1
      end

      sleep(0.5)
    end

    all_links = all_links.uniq
    puts "\nTotal unique recipe links found: #{all_links.count}"

    existing_count = all_links.count { |link| Recipe.exists?(source_url: link) }
    puts "Already have: #{existing_count}"
    puts "Will scrape: #{all_links.count - existing_count}"

    created_count = 0
    error_count = 0
    skipped_count = 0

    all_links.each_with_index do |link, index|
      if Recipe.exists?(source_url: link)
        skipped_count += 1
        next
      end

      begin
        created_count += 1 if scrape_cocktailvirgin_recipe(link)
      rescue StandardError => e
        puts "    Error: #{e.message}"
        error_count += 1
      end

      if (index + 1) % 50 == 0
        puts "\n  Progress: #{index + 1}/#{all_links.count} recipes checked"
        puts "  Created: #{created_count}, Skipped: #{skipped_count}, Errors: #{error_count}"
      end

      sleep(0.3)
    end

    puts "\nCocktailVirgin Results:"
    puts "  Created: #{created_count}"
    puts "  Skipped (already exist): #{skipped_count}"
    puts "  Errors: #{error_count}"
    puts "  Total recipes now: #{Recipe.count}"
  end

  def self.scrape_cocktailvirgin_recipe(url)
    response = HTTParty.get(url, headers: { 'User-Agent' => 'Mozilla/5.0' }, timeout: 10)

    unless response.success?
      puts "    Failed: #{response.code}"
      return false
    end

    doc = Nokogiri::HTML(response.body)

    title = doc.at_css('h3.post-title, h1.post-title, .entry-title')&.text&.strip

    if title.blank?
      puts '    No title found'
      return false
    end

    if Recipe.exists?(source_url: url)
      puts "    Already exists: #{title}"
      return false
    end

    ingredients = []

    # Extract ingredients from meta description
    meta_desc = doc.at_css('meta[property="og:description"]')&.[]('content')
    if meta_desc && meta_desc =~ /\d+.*(?:oz|ounce|ml)/i
      potential_ingredients = meta_desc.split(/\s{2,}/)
      potential_ingredients.each do |text|
        if text =~ %r{(?:\d+\s+)?\d+/\d+|\d+}i && text =~ /(oz|ounce|ml|dash|splash|tsp|tbsp)/i && (text.length < 150)
          ingredients << text.strip
        end
      end
    end

    # If no ingredients from meta, try HTML lists
    if ingredients.empty?
      doc.css('.post-body li, .entry-content li').each do |elem|
        text = elem.text.strip
        if (text =~ %r{(?:\d+\s+)?\d+/\d+\s*(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop|barspoon)}i ||
           text =~ /\d+\.?\d*\s*(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop|barspoon)/i) && (text.length < 150)
          ingredients << text
        end
      end
    end

    # If still no ingredients, try paragraphs
    if ingredients.empty?
      doc.css('.post-body p, .entry-content p').each do |elem|
        text = elem.text.strip
        if (text =~ %r{(?:\d+\s+)?\d+/\d+\s*(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop|barspoon)}i ||
           text =~ /\d+\.?\d*\s*(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop|barspoon)/i) && (text.length < 150)
          ingredients << text
        end
      end
    end

    # Extract instructions - look for short paragraphs with action verbs after ingredients
    instructions_elem = doc.at_css('.post-body, .entry-content')
    all_text = instructions_elem&.text&.strip || ''

    # Try to find just the instructions, not the full blog post
    paragraphs = all_text.split(/\n{2,}/)
    instruction_candidates = []
    found_ingredients = false

    paragraphs.each do |para|
      para = para.strip
      next if para.empty?

      # Check if this looks like ingredients (contains measurements)
      is_ingredient = para.match?(/\d+.*(?:oz|ounce|ml|dash|splash|tsp|tbsp|part|drop)/i) && para.length < 150

      if is_ingredient
        found_ingredients = true
        next
      end

      # After ingredients, look for instructions (short paragraph starting with action verb)
      next unless found_ingredients && para.length < 300

      is_instruction = para.match?(/^(Stir|Shake|Build|Combine|Pour|Add|Muddle|Strain|Garnish|Serve|Top|Fill|Mix|Blend)/i) ||
                       para.match?(/(?:stir|shake|strain|pour).*?(?:glass|ice)/i)

      next unless is_instruction

      instruction_candidates << para
      # Stop after we get 1-2 instruction paragraphs
      break if instruction_candidates.length >= 2
    end

    instructions = instruction_candidates.join("\n\n").presence || all_text

    image_url = doc.at_css('.post-body img, .entry-content img')&.[]('src')

    recipe = Recipe.create!(
      name: title,
      description: nil, # CocktailVirgin doesn't have dedicated descriptions, just blog stories
      instructions: instructions,
      image_url: image_url,
      source_url: url
    )

    # Parse ingredients
    ingredients.each do |ingredient_text|
      if match = ingredient_text.match(%r{^(>?\d+\s+\d+/\d+|\d+/\d+|>?\d+\.?\d*)\s*(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop|barspoon)s?\s+(.+)}i)
        amount = "#{match[1]} #{match[2]}"
        name = match[3]

        ingredient = find_or_create_ingredient(name.strip.titleize)
        recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: amount
        )
      elsif match = ingredient_text.match(%r{^([\d/.]+)\s+(oz|ounce|ml|dash|splash|tsp|tbsp|part|drop)s?\s+(.+)}i)
        amount = "#{match[1]} #{match[2]}"
        name = match[3]

        ingredient = find_or_create_ingredient(name.strip.titleize)
        recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: amount
        )
      else
        ingredient = find_or_create_ingredient(ingredient_text.strip.titleize)
        recipe.recipe_ingredients.create!(ingredient: ingredient)
      end
    end

    puts "  + #{recipe.name} (#{ingredients.count} ingredients)"
    true
  rescue StandardError => e
    puts "  Error scraping #{url}: #{e.message}"
    false
  end

  # Scrape diffordsguide.com
  def self.scrape_diffords
    puts "\n" + '=' * 50
    puts "Scraping Difford's Guide..."
    puts '=' * 50

    # Use sitemap to get all cocktail URLs
    puts 'Fetching sitemap...'
    all_links = []

    begin
      sitemap_url = 'https://www.diffordsguide.com/sitemap/cocktail.xml'
      response = HTTParty.get(sitemap_url, headers: {
                                'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
                              }, timeout: 30)

      if response.success?
        doc = Nokogiri::XML(response.body)
        all_links = doc.css('url loc').map(&:text).select { |url| url.include?('/cocktails/recipe/') }
        puts "Found #{all_links.count} cocktail URLs in sitemap"
      else
        puts "Failed to fetch sitemap: #{response.code}"
        return
      end
    rescue StandardError => e
      puts "Error fetching sitemap: #{e.message}"
      return
    end

    all_links = all_links.uniq
    puts "\nTotal unique cocktail links found: #{all_links.count}"

    existing_count = all_links.count { |link| Recipe.exists?(source_url: link) }
    puts "Already have: #{existing_count}"
    puts "Will scrape: #{all_links.count - existing_count}"

    created_count = 0
    error_count = 0
    skipped_count = 0

    all_links.each_with_index do |link, index|
      if Recipe.exists?(source_url: link)
        skipped_count += 1
        next
      end

      begin
        created_count += 1 if scrape_diffords_recipe(link)
      rescue StandardError => e
        puts "    Error: #{e.message}"
        error_count += 1
      end

      if (index + 1) % 50 == 0
        puts "\n  Progress: #{index + 1}/#{all_links.count} recipes checked"
        puts "  Created: #{created_count}, Skipped: #{skipped_count}, Errors: #{error_count}"
      end

      sleep(0.3)
    end

    puts "\nDifford's Guide Results:"
    puts "  Created: #{created_count}"
    puts "  Skipped (already exist): #{skipped_count}"
    puts "  Errors: #{error_count}"
    puts "  Total recipes now: #{Recipe.count}"
  end

  def self.scrape_diffords_recipe(url)
    response = HTTParty.get(url, headers: {
                              'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
                            }, timeout: 10)

    unless response.success?
      puts "    Failed: #{response.code}"
      return false
    end

    doc = Nokogiri::HTML(response.body)

    json_ld = nil
    doc.css('script[type="application/ld+json"]').each do |script|
      data = JSON.parse(script.text)
      if data['@type'] == 'Recipe'
        json_ld = data
        break
      end
    rescue JSON::ParserError
      next
    end

    if json_ld
      title = json_ld['name']
      ingredients = json_ld['recipeIngredient'] || []
      instructions = json_ld['recipeInstructions']
      if instructions.is_a?(Array)
        instructions = instructions.map { |step| step['text'] }.join("\n\n")
      elsif instructions.is_a?(Hash)
        instructions = instructions['text']
      end
      json_ld['description']
      image_url = json_ld.dig('image', 'url')
      glass = json_ld['recipeCategory']
    else
      title = doc.at_css('h1')&.text&.strip
      ingredients = []
      instructions = doc.at_css('[class*="instruction"], [class*="method"]')&.text&.strip
      image_url = nil
      glass = nil
    end

    if title.blank?
      puts '    No title found'
      return false
    end

    if Recipe.exists?(source_url: url)
      puts "    Already exists: #{title}"
      return false
    end

    recipe = Recipe.create!(
      name: title,
      description: description,
      instructions: instructions,
      image_url: image_url,
      source_url: url,
      glass: glass
    )

    ingredients.each do |ingredient_text|
      if match = ingredient_text.match(%r{^([\d/.]+\s*(?:ml|oz|dash|drop|part)?)\s+(.+)}i)
        amount = match[1].strip
        name = match[2].strip

        ingredient = find_or_create_ingredient(name.titleize)
        recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: amount
        )
      else
        ingredient = find_or_create_ingredient(ingredient_text.strip.titleize)
        recipe.recipe_ingredients.create!(ingredient: ingredient)
      end
    end

    puts "  + #{recipe.name} (#{ingredients.count} ingredients)"
    true
  rescue StandardError => e
    puts "  Error scraping #{url}: #{e.message}"
    false
  end

  # Scrape danielzajic.com (Anatomy of a Drink)
  def self.scrape_danielzajic
    puts "\n" + '=' * 50
    puts 'Scraping Daniel Zajic (Anatomy of a Drink)...'
    puts '=' * 50

    base_url = 'https://www.danielzajic.com'
    all_links = []
    seen_offsets = Set.new
    urls_to_visit = ["#{base_url}/cocktails", "#{base_url}/cocktail-series-archive"]
    page_count = 0
    max_pages = 200 # Safety limit

    # Process all URLs (main page + archive page with pagination)
    while urls_to_visit.any? && page_count < max_pages
      current_url = urls_to_visit.shift
      page_count += 1

      begin
        puts "  [Page #{page_count}] Fetching: #{current_url}"
        response = HTTParty.get(current_url, headers: { 'User-Agent' => 'Mozilla/5.0' }, timeout: 15)

        if response.success?
          doc = Nokogiri::HTML(response.body)

          # Extract recipe links from this page
          recipe_links = doc.css('a[href*="/cocktails/"]').map { |a| a['href'] }.uniq
          recipe_links.each do |href|
            next if href.nil?
            # Skip pagination links and non-recipe links
            next if href.include?('?')
            next unless href =~ %r{/cocktails/[^/]+$}

            full_url = href.start_with?('http') ? href : "#{base_url}#{href}"
            all_links << full_url unless all_links.include?(full_url)
          end

          puts "    Found #{all_links.count} total recipe links so far"

          # Look for all pagination links on this page
          doc.css('a').each do |a|
            href = a['href']
            next unless href && href =~ /\?offset=(\d+)/

            offset = ::Regexp.last_match(1)
            next if seen_offsets.include?(offset)

            seen_offsets.add(offset)
            next_url = href.start_with?('http') ? href : "#{base_url}#{href}"
            urls_to_visit << next_url unless urls_to_visit.include?(next_url)
            puts "    Queueing pagination: #{next_url}"
          end

          # Also check for any pagination in the raw HTML
          body_text = response.body
          offsets = body_text.scan(/offset=(\d+)/).flatten.uniq
          offsets.each do |offset|
            next if seen_offsets.include?(offset)

            seen_offsets.add(offset)
            next_url = "#{base_url}/cocktails?offset=#{offset}"
            unless urls_to_visit.include?(next_url)
              urls_to_visit << next_url
              puts "    Queueing pagination: #{next_url}"
            end
          end
        else
          puts "    Failed: #{response.code}"
        end
      rescue StandardError => e
        puts "    Error: #{e.message}"
      end

      sleep(1.0)  # 1 second delay between page requests
    end

    puts "\nTotal unique cocktail links found: #{all_links.count}"

    existing_count = all_links.count { |link| Recipe.exists?(source_url: link) }
    puts "Already have: #{existing_count}"
    puts "Will scrape: #{all_links.count - existing_count}"

    created_count = 0
    error_count = 0
    skipped_count = 0

    all_links.each_with_index do |link, index|
      if Recipe.exists?(source_url: link)
        skipped_count += 1
        next
      end

      begin
        created_count += 1 if scrape_danielzajic_recipe(link)
      rescue StandardError => e
        puts "    Error: #{e.message}"
        error_count += 1
      end

      puts "  Progress: #{index + 1}/#{all_links.count} recipes checked" if (index + 1) % 10 == 0

      sleep(1.0)  # 1 second delay between recipe requests
    end

    puts "\nDaniel Zajic Results:"
    puts "  Created: #{created_count}"
    puts "  Skipped (already exist): #{skipped_count}"
    puts "  Errors: #{error_count}"
    puts "  Total recipes now: #{Recipe.count}"
  end

  def self.scrape_danielzajic_recipe(url)
    response = HTTParty.get(url, headers: { 'User-Agent' => 'Mozilla/5.0' }, timeout: 15)

    unless response.success?
      puts "    Failed: #{response.code}"
      return false
    end

    doc = Nokogiri::HTML(response.body)

    # Try to find the title in various places
    title = nil
    # Look for h1 first, then try to extract from article header
    title_elem = doc.at_css('h1')
    if title_elem
      title = title_elem.text.strip
    else
      # Try to find title in article header or meta
      title_elem = doc.at_css('article h1, article h2, .blog-item-title, .entry-title')
      title = title_elem&.text&.strip
    end

    if title.blank?
      puts '    No title found'
      return false
    end

    if Recipe.exists?(source_url: url)
      puts "    Already exists: #{title}"
      return false
    end

    # Get the main content area
    content = doc.at_css('article, .entry-content, .post-content, main')&.text || ''
    unless content.downcase.match?(/(cocktail|ingredient|ounce|ml|stir|shake)/)
      puts "    Doesn't look like a cocktail recipe: #{title}"
      return false
    end

    # Extract ingredients - look for patterns like "2 oz. / 60 ml. Ingredient Name"
    ingredients = []

    # Method 1: Look for strong/bold text that might be ingredient amounts
    doc.css('p, li').each do |elem|
      text = elem.text.strip
      # Match patterns like: "2 oz. / 60 ml. Ingredient" or "½ oz. Ingredient" or "2 dashes Ingredient"
      next unless (text =~ /\d+.*(?:oz|ounce|ml|dash|dashes|splash|splashes|tsp|tbsp|drop|drops|barspoon|part|parts)/i ||
          text =~ /[½¼¾⅓⅔].*(?:oz|ounce|ml|dash|splash)/i) &&
                  text.length < 200 &&
                  !ingredients.include?(text) &&
                  !text.match?(/method|instructions|about|glass|garnish/i)

      ingredients << text
    end

    # Method 2: Look for paragraphs that contain multiple ingredient lines
    doc.css('p').each do |p|
      text = p.text.strip
      # Check if paragraph contains ingredient-like content
      lines = text.split(/\n|\r/)
      lines.each do |line|
        line = line.strip
        next unless (line =~ /^(\d+\.?\d*|[½¼¾⅓⅔])\s*(?:oz|ounce|ml|dash|dashes|splash|splashes|tsp|tbsp|drop|drops|barspoon|part|parts)/i ||
            line =~ /\d+\s*\.\s*\d+.*(?:oz|ml)/i) &&
                    line.length < 150 &&
                    !ingredients.include?(line) &&
                    !line.match?(/method|instructions|about|glass|garnish/i)

        ingredients << line
      end
    end

    # Extract instructions - look for METHOD section or long paragraphs
    instructions = ''
    method_found = false

    doc.css('p').each do |p|
      text = p.text.strip
      # Look for METHOD section
      next unless text =~ /^METHOD/i

      method_found = true
      instructions = text.sub(/^METHOD\s*/i, '').strip
      break
    end

    # If no METHOD section found, use longer paragraphs
    if instructions.blank?
      instructions_paras = doc.css('p').select do |p|
        text = p.text.strip
        text.length > 50 && text.length < 1500 && !text.match?(/^\d+.*(?:oz|ml)/i)
      end
      instructions = instructions_paras.map(&:text).join("\n\n").strip
    end

    # Get image URL
    image_url = doc.at_css('article img, .entry-content img, .post-content img, .image-block img')&.[]('src')
    image_url = "https://www.danielzajic.com#{image_url}" if image_url && !image_url.start_with?('http')

    recipe = Recipe.create!(
      name: title,
      description: nil, # Anatomy of a Drink doesn't have dedicated descriptions
      instructions: instructions,
      image_url: image_url,
      source_url: url
    )

    # Parse ingredients with improved regex
    ingredients.each do |ingredient_text|
      # Pattern 1: "2 oz. / 60 ml. Ingredient Name" or "2 oz. Ingredient Name"
      if match = ingredient_text.match(%r{^(.*?)(?:oz\.?|ounce|ml|dash|dashes|splash|splashes|tsp|tbsp|drop|drops|barspoon|part|parts)s?(?:\s*/\s*\d+.*?)?\s+(.+)$}i)
        amount = match[1].strip + ' ' + ingredient_text.match(/(oz\.?|ounce|ml|dash|dashes|splash|splashes|tsp|tbsp|drop|drops|barspoon|part|parts)/i)[0]
        name = match[2].strip

        ingredient = find_or_create_ingredient(name.titleize)
        recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: amount.strip
        )
      # Pattern 2: "½ oz. Ingredient" with Unicode fractions
      elsif match = ingredient_text.match(/^([½¼¾⅓⅔])\s*(oz\.?|ounce|ml|dash|splash|tsp|tbsp)\s+(.+)$/i)
        amount = match[1] + ' ' + match[2]
        name = match[3].strip

        ingredient = find_or_create_ingredient(name.titleize)
        recipe.recipe_ingredients.create!(
          ingredient: ingredient,
          amount: amount.strip
        )
      else
        # If we can't parse it, store the whole thing as the ingredient name
        ingredient = find_or_create_ingredient(ingredient_text.strip.titleize)
        recipe.recipe_ingredients.create!(ingredient: ingredient)
      end
    end

    puts "  + #{recipe.name} (#{ingredients.count} ingredients)"
    true
  rescue StandardError => e
    puts "  Error scraping #{url}: #{e.message}"
    false
  end

  # Run all scrapers
  def self.scrape_all
    puts "\n" + '=' * 60
    puts 'STARTING MASSIVE RECIPE SCRAPING SESSION'
    puts '=' * 60
    puts "Starting count: #{Recipe.count} recipes"
    puts ''

    begin
      scrape_thecocktaildb
    rescue StandardError => e
      puts "TheCocktailDB failed: #{e.message}"
    end

    begin
      scrape_cocktailvirgin
    rescue StandardError => e
      puts "CocktailVirgin failed: #{e.message}"
    end

    begin
      scrape_diffords
    rescue StandardError => e
      puts "Difford's Guide failed: #{e.message}"
    end

    begin
      scrape_danielzajic
    rescue StandardError => e
      puts "Daniel Zajic failed: #{e.message}"
    end

    puts "\n" + '=' * 60
    puts 'SCRAPING COMPLETE!'
    puts '=' * 60
    puts "Final recipe count: #{Recipe.count}"
    puts "New recipes added: #{Recipe.count - 322}"
    puts '=' * 60 + "\n"
  end

  # Get stats by source
  def self.stats
    all = Recipe.all

    virgin = all.select { |r| r.source_url && r.source_url.include?('cocktailvirgin') }.count
    difford = all.select { |r| r.source_url && r.source_url.include?('difford') }.count
    daniel = all.select { |r| r.source_url && r.source_url.include?('danielzajic') }.count
    db = all.select { |r| r.source_url && r.source_url =~ /^\d+$/ }.count
    other = all.count - virgin - difford - daniel - db

    puts "\nCurrent Recipe Statistics:"
    puts '-' * 40
    puts "CocktailVirgin:    #{virgin}"
    puts "Difford's Guide:   #{difford}"
    puts "Daniel Zajic:      #{daniel}"
    puts "TheCocktailDB:     #{db}"
    puts "Other:             #{other}" if other > 0
    puts '-' * 40
    puts "TOTAL:             #{all.count}"
    puts ''
  end
end
