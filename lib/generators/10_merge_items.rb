# frozen_string_literal: true

module MergeItems
  extend StardewValley

  class << self
    @additional_data = nil
    @image_data = nil

    def load_additional_data
      @additional_data = YAML.load_file('tmp/additional_item_data.yaml')['data']
    end

    def load_image_data
      @image_data = YAML.load_file('tmp/item_images.yaml')
    end

    def merge(id, data)
      load_additional_data unless @additional_data
      load_image_data unless @image_data

      data.merge!(data_for_id(id))
    end

    private

    def data_for_id(id)
      data = @additional_data[id] || {}
      data['image-link'] = @image_data[id] if @image_data[id]
      data
    end
  end

  generator('tmp/items.yaml', dependencies: %w[tmp/additional_item_data.yaml tmp/item_images.yaml]) do |id, data|
    merge(id, data)
    data['wiki-link'] ||= wiki_link(data['name']) unless data.delete('no-wiki')
    data
  end
end
