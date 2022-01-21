# frozen_string_literal: true

module StardewValley
  CATEGORIES = { -2 => 'Mineral (Gem)',  -4 => 'Fish', -5 => 'Animal Product (Egg)',  -6 => 'Animal Product (Milk)',
               -7 => 'Cooking', -8 => 'Crafting', -9 => 'Big Craftable', -12 => 'Mineral',
               -14 => 'Animal Product (Meat)', -15 => 'Resource (Metal)', -16 => 'Resource (Building)',
               -17 => "Sell at Pierre's",  -18 => "Animal Product (sell at Pierre's and Marnie's)", -19 => 'Fertilizer',
               -20 => 'Trash', -21 => 'Bait', -22 => 'Fishing Tackle', -23 => 'Sell at Fish Shop', -24 => 'Decor',
               -25 => 'Cooking (Ingredient)', -26 => 'Artisan Goods', -27 => 'Artisan Goods (Syrup)',
               -28 => 'Monster Loot', -29 => 'Equipment', -74 => 'Seed', -75 => 'Vegetable', -79 => 'Fruit',
               -80 => 'Flower', -81 => 'Forage', -95 => 'Hat', -96 => 'Ring', -98 => 'Weapon', -99 => 'Tool' }

  BUFFS = (%w[Farming Fishing Mining Digging Luck Foraging Crafting] << 'Max Energy') + %w[Magnetism Speed Defense Attack]

  class << self
    def base(data)
      type, category = data[3].split(' ')
      hash = { 'name' => data[0], 'value' => data[1].to_i, 'edibility' => data[2].to_i, 'type' => type,
               'description' => data[5] }
      hash['category'] = CATEGORIES[category.to_i] if category
      hash
    end

    def check_fish(hash, data)
      return unless hash['type'] == 'Fish' && data.length > 6

      hash['fish_data'] = data[6]
    end

    def duration(value)
      min = value.to_i * 0.7 / 60
      sec = min % 1
      min -= 1
      min = min.round(0)
      sec *= 60
      sec = sec.round(0)
      { 'duration' => "#{min}min #{sec}s", 'duration_raw' => value.to_i }
    end

    def buffs(buff, duration)
      return unless buff && duration && duration != '0'

      buff.split(' ').each.with_index.reduce(duration(duration)) do |hash, tmp|
        n, i = tmp
        hash[BUFFS[i]] = "+#{n}" if n != '0'
        hash
      end
    end

    def check_buffs(hash, data)
      return unless %w[drink food].include? data[6]

      sym = data[6]
      hash[sym] = {}
      buffs = buffs(data[7], data[8])
      hash[sym]['buffs'] = buffs if buffs
      hash[sym]['Energy Restored'] = (data[2] * 2.5).to_i
      hash[sym]['Health Restored'] = (data[2] * 2.5 * 0.45).to_i
    end

    def check_geodes(hash, data)
      return unless data[0].downcase.match('geode')

      hash[:possible_items] = data[6].split(' ').map(&:to_i)
    end
  end

  generator('raw/items.xnb', target: 'tmp/items.yaml', keys: ->(key) { key.to_i }) do |_, data|
    data = data.split('/')
    hash = base(data)
    %i[check_fish check_buffs check_geodes].each { |sym| self.send(sym, hash, data)}
    hash
  end
end
