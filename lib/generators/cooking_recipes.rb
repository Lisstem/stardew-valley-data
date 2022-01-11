# frozen_string_literal: true

module StardewValley
  class << self
    def q(day, season, year)
      "The Queen of Sauce (#{day} #{SEASONS[season - 1]}, Year #{year}"
    end

    def s(amount)
      "Stardrop Saloon for #{amount}g"
    end

    def v(name, hearts)
      "#{name} (Mail - #{hearts}+ hearts)"
    end

    def make_sources
      sources = {}
      sources["Fried Egg"] = 'Upgraded farmhouse'
      sources["Omelet"] = q(28, 7, 1).or s(100)
      sources["Salad"] = v('Emily', 3)
      sources["Cheese Cauliflower"] = v('Pam', 3)
      sources["Baked Fish"] = q(7, 2, 1)
      sources["Parsnip Soup"] = v('Caroline', 3)
      sources["Vegetable Stew"] = v('Caroline', 7)
      sources["Complete Breakfast"] = q(21, 1, 2)
      sources["Fried Calamari"] = v('Jodi', 3)
      sources["Strange Bun"] = v('Shane', 7)
      sources["Lucky Lunch"] = q(28, 1, 2)
      sources["Fried Mushroom"] = v('Demetrius', 3)
      sources["Pizza"] = q(7, 1, 2).or s(150)
      sources["Bean Hotpot"] = v('Clint', 7)
      sources["Glazed Yams"] = q(21, 3, 1)
      sources["Carp Surprise"] = q(7, 2, 2)
      sources["Hashbrowns"] = q(14, 1 ,2).or s(150)
      sources["Pancakes"] = q(14, 1, 2).or s(100)
      sources["Salmon Dinner"] = v('Gus', 3)
      sources["Fish Taco"] = v('Linus', 7)
      sources["Crispy Bass"] = v('Kent', 3)
      sources["Pepper Poppers"] = v('Shane', 3)
      sources["Bread"] = q(28, 2, 1).or s(100)
      sources["Tom Kha Soup"] = v('Sandy', 7)
      sources["Trout Soup"] = q(14, 3, 1)
      sources["Chocolate Cake"] = q(14, 4, 1)
      sources["Pink Cake"] = q(21, 2, 2)
      sources["Rhubarb Pie"] = v('Marnie', 7)
      sources["Cookies"] = 'Evelyn (4-heart event)'
      sources["Spaghetti"] = v('Lewis', 3)
      sources["Fried Eel"] = v('George', 3)
      sources["Spicy Eel"] = v('George', 7)
      sources["Sashimi"] = v('Linus', 3)
      sources["Maki Roll"] = q(21, 1, 1).or s(300)
      sources["Tortilla"] = q(7, 3, 1).or s(100)
      sources["Red Plate"] = v('Emily', 7)
      sources["Eggplant Parmesan"] = v('Lewis', 7)
      sources["Rice Pudding"] = v('Evelyn', 7)
      sources["Ice Cream"] = v('Jodi', 7)
      sources["Blueberry Tart"] = v('Pierre', 3)
      sources["Autumn's Bounty"] = v('Demetrius', 7)
      sources["Pumpkin Soup"] = v('Robin', 7)
      sources["Super Meal"] = v('Kent', 7)
      sources["Cranberry Sauce"] = v('Gus', 7)
      sources["Stuffing"] = v('Pam', 7)
      sources["Farmer's Lunch"] = 'Farming Level 3'
      sources["Survival Burger"] = 'Foraging Level 2'
      sources["Dish o' The Sea"] = 'Fishing Level 3'
      sources["Miner's Treat"] = 'Mining Level 3'
      sources["Roots Platter"] = 'Combat Level 3'
      sources["Triple Shot Espresso"] = s(5000)
      sources["Seafoam Pudding"] = 'Fishing Level 9'
      sources["Algae Soup"] =  v('Clint', 3)
      sources["Pale Broth"] = v('Marnie', 3)
      sources["Plum Pudding"] = q(7, 4, 1)
      sources["Artichoke Dip"] = q(28, 3, 1)
      sources["Stir Fry"] = q(7, 1, 1)
      sources["Roasted Hazelnuts"] = q(28, 2, 2)
      sources["Pumpkin Pie"] = q(21, 4, 1)
      sources["Radish Salad"] = q(21, 1, 1)
      sources["Fruit Salad"] = q(7, 3, 2)
      sources["Blackberry Cobbler"] = q(14, 3, 2)
      sources["Cranberry Candy"] = q(28, 4, 1)
      sources["Bruschetta"] = q(21, 4, 2)
      sources["Coleslaw"] = q(14, 1, 1)
      sources["Fiddlehead Risotto"] = q(28, 3, 2)
      sources["Poppyseed Muffin"] = q(7, 4, 2)
      sources["Chowder"] = v('Willy', 3)
      sources["Fish Stew"] = v('Willy', 7)
      sources["Escargot"] = v('Willy', 5)
      sources["Lobster Bisque"] = q(14, 4, 2).or v('Willy', 9)
      sources["Maple Bar"] = q(14, 2, 2)
      sources["Crab Cakes"] = q(21, 3, 2)
      sources["Shrimp Cocktail"] = q(28, 3, 2)
      sources["Ginger Ale"] = 'Dwarf Shop in Volcano on Ginger Island for 1,000g'
      sources["Banana Pudding"] = 'Island Trader for 30 Bone Fragments'
      sources["Mango Sticky Rice"] = v('Leo', 7)
      sources["Poi"] = v('Leo', 3)
      sources["Tropical Curry"] = 'Ginger Island Resort'
      sources["Squid Ink Ravioli"] = 'Combat Level 9'
      sources
    end
  end

  SOURCES = make_sources
  generator('cooking_recipes.json', 'wiki-link' => 'https://stardewcommunitywiki.com/Cooking#Recipes') do |name, ingredients|
    { 'ingredients' => ingredients,
      'image' => image_link(name),
      'wiki-link' => wiki_link(name),
      'source' => SOURCES[name]
    }
  end
end
