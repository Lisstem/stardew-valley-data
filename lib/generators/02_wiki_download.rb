# frozen_string_literal: true
require 'net/http'

module WikiDownload
  extend StardewValley

  class << self
    def data_function
      download_html('https://stardewvalleywiki.com/Modding:Items/Object_sprites').to_yaml
    end

    private

    def download_html(uri)
      response = Net::HTTP.get_response(URI(uri))

      raise Exception.new('Error: could not download html from wiki.') if response.code != '200'

      puts "\t... got #{uri}."
      response.body
    end
  end

  generator('raw/blank.yaml.erb', target: 'tmp/item_images.html', no_transform: true) { }
end
