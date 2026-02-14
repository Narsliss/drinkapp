class IngredientCategorizer
  # Define ingredient categories and their patterns
  CATEGORIES = {
    'Rum - Jamaican' => [
      /\bjamaican rum\b/i, /\bappleton\b/i, /\bmyers\b/i, /\bwray\s+&\s*nephew\b/i,
      /\bsmith\s*&\s*cross\b/i, /\bdoctor\s*bird\b/i, /\brum\s+bar\b/i,
      /\bhamilton\s+jamaican\b/i, /\bplantation\s+(xaymaca|jamaica)\b/i
    ],
    'Rum - Flavored' => [
      /\bcoconut rum\b/i, /\bpineapple rum\b/i, /\bspiced rum\b/i, /\bvanilla rum\b/i,
      /\bmango rum\b/i, /\bpassion\s+fruit\s+rum\b/i, /\bstrawberry\s+rum\b/i,
      /\bbanana rum\b/i, /\bcherry rum\b/i, /\bmalibu\b/i, /\bcaptain\s+morgan\s+spiced\b/i,
      /\bkahlúa\s+rum\b/i, /\bparrot\s+bay\b/i
    ],
    'Rum - Dark/Aged' => [
      /\bdark rum\b/i, /\baged rum\b/i, /\bblack rum\b/i, /\bgold rum\b/i,
      /\boverproof rum\b/i, /\bdemerara rum\b/i, /\baged\s+\d+\s+year/i,
      /\bextra\s+aged\b/i, /\breserve\b/i, /\banjejo\b/i,
      /\bgosling/i, /\bkraken\b/i, /\bplantation\s+(?!jamaica|xaymaca)\b/i
    ],
    'Rum - White/Light' => [
      /\bwhite rum\b/i, /\blight rum\b/i, /\bsilver rum\b/i, /\bclear rum\b/i,
      /\bblanco rum\b/i, /\bplatinum rum\b/i, /\bpuerto rican rum\b/i,
      /\bcuban rum\b/i, /\bbarbados rum\b/i, /\bmount gay\b/i,
      /\bbacardi\s+(superior|blanco|light|cart)\b/i, /\bflor de caña\s+(4|extra|dry)\b/i
    ],
    'Rum - Other' => [
      /\brum\b/i, /\b diplomatico\b/i
    ],
    'Agave Spirits' => [
      /\bmezcal\b/i, /\btequila\b/i, /\bblanco tequila\b/i, /\breposado\b/i,
      /\banejo\b/i, /\bextra anejo\b/i, /\bpatron\b/i, /\bdon julio\b/i,
      /\bespolon\b/i, /\bcazadores\b/i, /\bhornitos\b/i, /\bjose cuervo\b/i,
      /\bsauza\b/i, /\b1800\b/i, /\bcorralejo\b/i, /\bel jimador\b/i,
      /\bclase azul\b/i, /\bcasamigos\b/i, /\bel tesoro\b/i, /\bfortaleza\b/i
    ],
    'Vodka' => [
      /\bvodka\b/i, /\babsolut\b/i, /\bsmirnoff\b/i, /\bketel one\b/i,
      /\bgrey goose\b/i, /\btito/i, /\bbelvedere\b/i
    ],
    'Gin' => [
      /\bgin\b/i, /\bplymouth gin\b/i, /\blondon dry gin\b/i, /\b Tanqueray\b/i,
      /\bbombay sapphire\b/i, /\bbeefeater\b/i, /\bhendrick/i
    ],
    'Whiskey' => [
      /\bwhiskey\b/i, /\bwhisky\b/i, /\bbourbon\b/i, /\brye whiskey\b/i,
      /\bscotch\b/i, /\bblended whiskey\b/i, /\birish whiskey\b/i,
      /\bjapanese whisky\b/i, /\bcanadian whisky\b/i, /\btennessee whiskey\b/i,
      /\bjack daniel/i, /\bjim beam\b/i, /\b Maker's mark\b/i, /\b Woodford\b/i,
      /\bbulleit\b/i, /\bhighland park\b/i, /\bglenfiddich\b/i, /\bmacallan\b/i,
      /\bwild turkey\b/i, /\b buffalo trace\b/i, /\b four roses\b/i,
      /\bknob creek\b/i, /\bold forester\b/i, /\bevan williams\b/i,
      /\bcanadian club\b/i, /\bcrown royal\b/i, /\bjameson\b/i,
      /\bbushmills\b/i, /\bred breast\b/i, /\btullamore dew\b/i
    ],
    'Brandy' => [
      /\bbrandy\b/i, /\bcognac\b/i, /\barmagnac\b/i, /\bpisco\b/i,
      /\bgrappa\b/i, /\bcalvados\b/i, /\beaujolais\b/i,
      /\bremy martin\b/i, /\bhennessy\b/i, /\bcourvoisier\b/i,
      /\basbach\b/i, /\be&j\b/i, /\bhennessy\b/i
    ],
    'Liqueur - Orange/Curaçao' => [
      /\btriple sec\b/i, /\bcointreau\b/i, /\bgrand marnier\b/i,
      /\bcura[çc]ao\b/i, /\bblue cura[çc]ao\b/i, /\borange cura[çc]ao\b/i,
      /\bblue curacao\b/i, /\borange curacao\b/i, /\bcuracao\b/i,
      /\bcombier\b/i, /\bpierre ferrand\b/i, /\bdry cura[çc]ao\b/i,
      /\borange liqueur\b/i, /\bbauchant\b/i
    ],
    'Liqueur - Coffee' => [
      /\bkahl[úu]a\b/i, /\bkahlua\b/i, /\bcoffee liqueur\b/i, /\bespresso liqueur\b/i,
      /\borghetti\b/i, /\bmr\. black\b/i, /\billy espresso\b/i,
      /\bgalliano ristretto\b/i, /\bristretto\b/i, /\bnola coffee liqueur\b/i,
      /\bst\. george nola\b/i, /\bcafé liqueur\b/i
    ],
    'Liqueur - Maraschino' => [
      /\bmaraschino liqueur\b/i, /\bluxardo\b/i, /\blazzaroni maraschino\b/i,
      /\bmaraschino\b/i
    ],
    'Liqueur - Nut' => [
      /\bamaretto\b/i, /\bfrangelico\b/i, /\bhazelnut liqueur\b/i,
      /\bpecan liqueur\b/i, /\bwalnut liqueur\b/i, /\bpistachio\b/i,
      /\bnocino\b/i
    ],
    'Liqueur - Fruit' => [
      /\bapricot liqueur\b/i, /\bpeach liqueur\b/i, /\bpeach schnapps\b/i,
      /\bcreme de peche\b/i, /\bbanana liqueur\b/i, /\bgreen banana liqueur\b/i,
      /\bberry liqueur\b/i, /\braspberry liqueur\b/i, /\bblackberry liqueur\b/i,
      /\bblueberry liqueur\b/i, /\bstrawberry liqueur\b/i, /\bcherry liqueur\b/i,
      /\bcranberry liqueur\b/i, /\bpineapple liqueur\b/i, /\bmango liqueur\b/i,
      /\bpassionfruit liqueur\b/i, /\bpassion fruit liqueur\b/i,
      /\bwatermelon liqueur\b/i, /\bmelon liqueur\b/i, /\bgreen melon liqueur\b/i,
      /\bmidori\b/i, /\bmidori melon\b/i, /\bapple liqueur\b/i,
      /\bapple schnapps\b/i, /\bpear liqueur\b/i, /\bspiced pear liqueur\b/i,
      /\bpamplemousse liqueur\b/i, /\bgrapefruit liqueur\b/i,
      /\bblood orange liqueur\b/i, /\bmandarin liqueur\b/i,
      /\bplum liqueur\b/i, /\bfig liqueur\b/i, /\bapry\b/i,
      /\brothman.*apricot\b/i, /\brothman.*pear\b/i,
      /\bclear creek loganberry\b/i, /\blingonberry liqueur\b/i,
      /\bcloudberry liqueur\b/i, /\bmyrtle liqueur\b/i, /\bmirto liqueur\b/i,
      /\bwatermelon schnapps\b/i
    ],
    'Liqueur - Herbal/Floral' => [
      /\belderflower liqueur\b/i, /\bst-germain\b/i, /\bst\. germain\b/i,
      /\bst\. elder\b/i, /\bst elder\b/i, /\bchartreuse\b/i,
      /\bgreen chartreuse\b/i, /\byellow chartreuse\b/i,
      /\bstrega\b/i, /\bsuze\b/i, /\bsalers\b/i, /\baveze\b/i,
      /\bavèze\b/i, /\bgentian liqueur\b/i, /\bdimmi\b/i,
      /\bhpnotiq\b/i, /\bparfait amour\b/i, /\bchareau\b/i,
      /\baloe liqueur\b/i, /\bthyme liqueur\b/i, /\brose liqueur\b/i,
      /\brose petal liqueur\b/i, /\belixir liqueur\b/i, /\bgenépi\b/i,
      /\bgénépi\b/i, /\bkummel\b/i, /\bmastiha\b/i, /\bkrupnik\b/i,
      /\bbecherovka\b/i, /\bpacharan\b/i, /\bgoldwasser\b/i,
      /\bl'esprit de june\b/i, /\bzirbenz\b/i
    ],
    'Liqueur - Cream' => [
      /\bbaileys\b/i, /\bbailey'?s\b/i, /\birish cream\b/i,
      /\bcream liqueur\b/i, /\badvocaat\b/i, /\begg liqueur\b/i,
      /\brompope\b/i
    ],
    'Liqueur - Chocolate' => [
      /\bchocolate liqueur\b/i, /\bdark chocolate liqueur\b/i,
      /\bdk chocolate liqueur\b/i
    ],
    'Liqueur - Ginger' => [
      /\bginger liqueur\b/i, /\bking'?s ginger\b/i, /\bdomaine de canton\b/i,
      /\bsnap ginger\b/i, /\bgiffard ginger\b/i
    ],
    'Liqueur - Anise' => [
      /\bsambuca\b/i, /\bblack sambuca\b/i, /\bwhite sambuca\b/i,
      /\babsinthe\b/i, /\bpernod\b/i, /\bpastis\b/i,
      /\banisette\b/i, /\baniseed liqueur\b/i, /\bouzo\b/i,
      /\braki\b/i, /\barak\b/i
    ],
    'Amaro - Fernet' => [
      /\bfernet\b/i, /\bfernet branca\b/i, /\bmint fernet\b/i
    ],
    'Amaro - Cynar' => [
      /\bcynar\b/i, /\bcynar 70\b/i, %r{\bcynar/carciofo\b}i
    ],
    'Amaro - Averna' => [
      /\bamaro averna\b/i, /\baverna\b/i
    ],
    'Amaro - Nonino' => [
      /\bamaro nonino\b/i, /\bnonino\b/i
    ],
    'Amaro - Montenegro' => [
      /\bamaro montenegro\b/i, /\bmontenegro\b/i
    ],
    'Amaro - Meletti' => [
      /\bamaro meletti\b/i, /\bmeletti\b/i
    ],
    'Amaro - Alpine' => [
      /\bamaro braulio\b/i, /\bamaro sfumato\b/i, /\bamaro zucca\b/i,
      /\bzucca rabarbaro\b/i, /\bamaro del capo\b/i, /\bvecchio amaro\b/i,
      /\bamaro abano\b/i, /\bamaro sibilla\b/i, /\bluxardo amaro\b/i
    ],
    'Amaro - Other' => [
      /\bamaro\b/i, /\bamaro lucano\b/i, /\bamaro nardini\b/i,
      /\bamaro ramazzotti\b/i, /\bamaro ciociaro\b/i, /\bcardamaro\b/i,
      /\bchin?a china\b/i, /\bamaro ciociaro\b/i
    ],
    'Liqueur - Other' => [
      /\bliqueur\b/i, /\bschnapps\b/i, /\bpeppermint schnapps\b/i,
      /\bcaramel liqueur\b/i, /\btoffee liqueur\b/i, /\bbutterscotch liqueur\b/i,
      /\bvanilla liqueur\b/i, /\bcinnamon liqueur\b/i, /\bhoney liqueur\b/i,
      /\bmaple liqueur\b/i, /\bmustard liqueur\b/i, /\btobacco liqueur\b/i,
      /\broot liqueur\b/i, /\bdrambuie\b/i,
      /\bbenedicte?\b/i, /\bsloe gin\b/i, /\bdamson gin\b/i,
      /\bpink gin\b/i, /\bcreme de violet\b/i, /\bcrème yvette\b/i,
      /\bgalliano\b/i, /\bchambord\b/i, /\bfalernum\b/i,
      /\btuaca\b/i, /\bnavan\b/i, /\biguazu\b/i
    ],
    'Vermouth' => [
      /\bvermouth\b/i, /\bsweet vermouth\b/i, /\bdry vermouth\b/i,
      /\brosso vermouth\b/i, /\bblanc vermouth\b/i, /\bwhite vermouth\b/i,
      /\brouge vermouth\b/i, /\b Carpano\b/i, /\bduff\b/i,
      /\b Cocchi\b/i, /\bnoilly prat\b/i, /\bmartini rosso\b/i,
      /\bmartini dry\b/i, /\b Cinzano\b/i
    ],
    'Wine' => [
      /\bwine\b/i, /\bwhite wine\b/i, /\bred wine\b/i, /\bsparkling wine\b/i,
      /\bchampagne\b/i, /\bprosecco\b/i, /\bcava\b/i, /\bmoscato\b/i,
      /\bport\b/i, /\bsherry\b/i, /\b madeira\b/i,
      /\bsake\b/i, /\bsoju\b/i
    ],
    'Juice' => [
      /\bjuice\b/i, /\borange juice\b/i, /\bcranberry juice\b/i,
      /\bgrapefruit juice\b/i, /\blime juice\b/i, /\blemon juice\b/i,
      /\bpineapple juice\b/i, /\btomato juice\b/i, /\bapple juice\b/i,
      /\bgrape juice\b/i, /\bpomegranate juice\b/i, /\bpassion fruit juice\b/i,
      /\bmango juice\b/i, /\bpeach juice\b/i, /\bpear juice\b/i,
      /\bclamato\b/i, /\bcoconut water\b/i
    ],
    'Soda/Mixer' => [
      /\bsoda\b/i, /\bclub soda\b/i, /\btonic water\b/i, /\bginger ale\b/i,
      /\bginger beer\b/i, /\bcola\b/i, /\blemon-lime soda\b/i, /\b sprite\b/i,
      /\b7-up\b/i, /\bmountain dew\b/i, /\benergy drink\b/i,
      /\bsparkling water\b/i, /\bseltzer\b/i, /\bmineral water\b/i
    ],
    'Syrup' => [
      /\bsyrup\b/i, /\bsimple syrup\b/i, /\bgrenadine\b/i, /\borgeat\b/i,
      /\bagave syrup\b/i, /\bhoney syrup\b/i, /\bmaple syrup\b/i,
      /\bcinnamon syrup\b/i, /\bvanilla syrup\b/i, /\bginger syrup\b/i,
      /\bpassion fruit syrup\b/i, /\bcherry syrup\b/i, /\braspberry syrup\b/i,
      /\bstrawberry syrup\b/i, /\bmint syrup\b/i, /\blavender syrup\b/i,
      /\brose syrup\b/i, /\bdemerara syrup\b/i, /\brich syrup\b/i,
      /\bsugar syrup\b/i, /\brock candy syrup\b/i
    ],
    'Bitters - Angostura' => [
      /\bangostura bitters\b/i, /\bangostura aromatic bitters\b/i
    ],
    'Bitters - Peychaud\'s' => [
      /\bpeychaud'?s bitters\b/i, /\bpeychaud bitters\b/i
    ],
    'Bitters - Orange' => [
      /\borange bitters\b/i, /\bregan'?s orange bitters\b/i, /\bfee'?s orange bitters\b/i,
      /\bangostura orange bitters\b/i
    ],
    'Bitters - Chocolate/Mole' => [
      /\bchocolate bitters\b/i, /\bmole bitters\b/i, /\bxocolatl bitters\b/i,
      /\bbittermens mole bitters\b/i, /\bbitter truth chocolate bitters\b/i
    ],
    'Bitters - Fruit' => [
      /\bcherry bitters\b/i, /\bpeach bitters\b/i, /\bplum bitters\b/i,
      /\bgrapefruit bitters\b/i, /\bapple bitters\b/i, /\bcranberry bitters\b/i,
      /\blemon bitters\b/i, /\blime bitters\b/i
    ],
    'Bitters - Aromatic' => [
      /\baromatic bitters\b/i, /\bboker'?s bitters\b/i, /\babbotts bitters\b/i,
      /\babbott'?s bitters\b/i, /\bblack walnut bitters\b/i, /\bwalnut bitters\b/i,
      /\bhouse aromatic bitters\b/i
    ],
    'Bitters - Specialty' => [
      /\bcelery bitters\b/i, /\bcardamom bitters\b/i, /\bginger bitters\b/i,
      /\btiki bitters\b/i, /\bcreole bitters\b/i, /\borinoco bitters\b/i,
      /\btorani amer\b/i, /\bamargo bitters\b/i, /\bbitter bianco\b/i,
      /\bdaiquiri bitters\b/i, /\bmaple bitters\b/i, /\bvanilla bitters\b/i,
      /\bwormwood bitters\b/i, /\blavender bitters\b/i, /\bmint bitters\b/i
    ],
    'Bitters - Other' => [
      /\bbitters\b/i
    ],
    'Cream/Dairy' => [
      /\bcream\b/i, /\bheavy cream\b/i, /\bwhipping cream\b/i, /\bhalf and half\b/i,
      /\bmilk\b/i, /\bwhole milk\b/i, /\bskim milk\b/i, /\bcondensed milk\b/i,
      /\bevaporated milk\b/i, /\bcoconut cream\b/i, /\bcoconut milk\b/i,
      /\begg white\b/i, /\begg yolk\b/i, /\bwhole egg\b/i,
      /\bbutter\b/i, /\byogurt\b/i
    ],
    'Fresh Fruit' => [
      /\blemon\b/i, /\blime\b/i, /\borange\b/i, /\bgrapefruit\b/i,
      /\bpineapple\b/i, /\bstrawberry\b/i, /\braspberry\b/i, /\bblueberry\b/i,
      /\bblackberry\b/i, /\bcherry\b/i, /\bpeach\b/i, /\bmango\b/i,
      /\bpassion fruit\b/i, /\bkiwi\b/i, /\bapple\b/i, /\bpear\b/i,
      /\bwatermelon\b/i, /\bcantaloupe\b/i, /\bhoneydew\b/i,
      /\bgrapes\b/i, /\bfig\b/i, /\bpomegranate\b/i, /\bplum\b/i,
      /\bapricot\b/i, /\bnectarine\b/i, /\bcucumber\b/i
    ],
    'Herbs/Spices' => [
      /\bmint\b/i, /\bbasil\b/i, /\brosemary\b/i, /\bthyme\b/i,
      /\bsage\b/i, /\bcilantro\b/i, /\bdill\b/i, /\btarragon\b/i,
      /\bginger\b/i, /\bcinnamon\b/i, /\bnutmeg\b/i, /\bcloves\b/i,
      /\bstar anise\b/i, /\bcardamom\b/i, /\bvanilla\b/i, /\blavender\b/i,
      /\brose petals\b/i, /\bsaffron\b/i
    ],
    'Garnish' => [
      /\bgarnish\b/i, /\bcherry\b/i, /\bolive\b/i, /\bonion\b/i,
      /\bcitrus twist\b/i, /\blemon twist\b/i, /\blime twist\b/i,
      /\borange twist\b/i, /\blemon peel\b/i, /\blime peel\b/i,
      /\borange peel\b/i, /\blime wheel\b/i, /\blemon wheel\b/i,
      /\borange wheel\b/i, /\bgrapefruit wheel\b/i,
      /\bmint sprig\b/i, /\bbasil leaf\b/i
    ],
    'Beer' => [
      /\bbeer\b/i, /\blager\b/i, /\bale\b/i, /\bstout\b/i, /\bporter\b/i,
      /\bipa\b/i, /\bwheat beer\b/i, /\bpilsner\b/i, /\b Guinness\b/i,
      /\bheineken\b/i, /\bbudweiser\b/i, /\bcorona\b/i, /\bmodelo\b/i
    ],
    'Other' => [
      /\bwater\b/i, /\bice\b/i, /\bsalt\b/i, /\bsugar\b/i, /\bsuperfine sugar\b/i,
      /\bbrown sugar\b/i, /\bpowdered sugar\b/i, /\bgranulated sugar\b/i,
      /\bcoffee\b/i, /\bespresso\b/i, /\btea\b/i, /\bhot water\b/i,
      /\bcold water\b/i, /\bsparkling water\b/i, /\bwater\b/i,
      /\bcocoa powder\b/i, /\bchocolate\b/i, /\bchocolate syrup\b/i,
      /\bvanilla extract\b/i, /\balmond extract\b/i, /\brose water\b/i,
      /\borange flower water\b/i, /\b Worcestershire\b/i, /\btabasco\b/i,
      /\bhot sauce\b/i, /\bsriracha\b/i, /\bsoy sauce\b/i,
      /\btamarind\b/i, /\bhoney\b/i, /\bagave nectar\b/i,
      /\bmaple syrup\b/i, /\bmolasses\b/i
    ]
  }.freeze

  def self.categorize_all_ingredients
    puts 'Categorizing ingredients...'

    # Create categories
    CATEGORIES.keys.each do |category_name|
      IngredientCategory.find_or_create_by!(name: category_name)
    end

    categorized_count = 0
    uncategorized = []

    Ingredient.find_each do |ingredient|
      category = find_category_for(ingredient.name)

      if category
        ingredient.update!(category: category)
        categorized_count += 1
        puts "  #{ingredient.name} → #{category.name}"
      else
        uncategorized << ingredient.name
      end
    end

    puts "\nCategorized: #{categorized_count}/#{Ingredient.count} ingredients"

    return unless uncategorized.any?

    puts "\nUncategorized ingredients (#{uncategorized.count}):"
    uncategorized.sort.each { |name| puts "  - #{name}" }
  end

  def self.find_category_for(ingredient_name)
    CATEGORIES.each do |category_name, patterns|
      patterns.each do |pattern|
        return IngredientCategory.find_by(name: category_name) if ingredient_name =~ pattern
      end
    end
    nil
  end

  # Get all ingredients in a category
  def self.ingredients_in_category(category_name)
    category = IngredientCategory.find_by(name: category_name)
    return [] unless category

    category.ingredients.pluck(:id)
  end

  # Check if ingredient belongs to a category
  def self.ingredient_in_category?(ingredient, category_name)
    return false unless ingredient.category

    ingredient.category.name == category_name
  end
end
