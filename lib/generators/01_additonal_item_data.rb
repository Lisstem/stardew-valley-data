# frozen_string_literal: true

module AdditionalItemData
  extend StardewValley
  generator('raw/additional_item_data.yaml.erb', target: 'tmp/additional_item_data.yaml') { |_, data| data }
end
