# frozen_string_literal: true

module MergeItems
  extend StardewValley

  class << self
    @additional_data = nil

    def load_additional_data
      @additional_data = YAML.load_file('tmp/additional_item_data.yaml')['data']
    end

    def merge(id, data)
      load_additional_data unless @additional_data

      data.merge!(@additional_data[id] || {})
    end
  end

  generator('tmp/items.yaml', dependencies: %w[tmp/additional_item_data.yaml]) do |id, data|
    merge(id, data)
    data['wiki-link'] ||= wiki_link(data['name']) unless data.delete('no-wiki')
    data
  end
end
