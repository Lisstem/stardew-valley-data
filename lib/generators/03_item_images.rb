# frozen_string_literal: true

require 'nokogiri'

module ItemImages
  extend StardewValley

  class << self
    def data_function
      doc = File.open('tmp/item_images.html') { |f| Nokogiri::HTML(f) }
      rows = doc.css(".wikitable tr").drop(1).each_slice(2).map(&:first)
      entries = rows.flat_map { |r| r.css('td') }
      images = entries.map.with_index { |e,i| [i, e.css('img')&.first&.[]('srcset')]  }.to_h.compact
      images.transform_values! { |i| wiki_link(i.split(',').last.strip.split(/\s/).first) }
      images.to_yaml
    end
  end

  generator('raw/blank.yaml.erb', target: 'tmp/item_images.yaml', no_transform: true, dependencies: 'tmp/item_images.html') {}
end
