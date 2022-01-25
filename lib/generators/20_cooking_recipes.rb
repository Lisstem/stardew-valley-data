# frozen_string_literal: true

module CookingRecipes
  extend StardewValley

  class << self
    def q(day, season, year)
      "The Queen of Sauce (#{day} #{SEASONS[season - 1]}, Year #{year})"
    end

    def s(amount)
      "Stardrop Saloon for #{amount}g"
    end

    def v(name, hearts)
      "#{name} (Mail - #{hearts}+ hearts)"
    end
  end

  generator('raw/cooking_recipes.yaml.erb', 'wiki-link' => 'https://stardewcommunitywiki.com/Cooking#Recipes') do |name, hash|
    hash['wiki-link'] ||= wiki_link(name)
    hash
  end
end
