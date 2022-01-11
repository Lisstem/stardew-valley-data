# frozen_string_literal: true

module StardewValley
  WIKI_URL = 'https://stardewcommunitywiki.com'
  SEASONS = %w[Spring Summer Fall Winter]
  class << self
    def wiki_link(name)
      "#{WIKI_URL}/#{name.underscore}"
    end

    def image_link(name)
      "#{WIKI_URL}/FILE:#{name.underscore}.png"
    end

    def read_json(path)
      JSON.parse(File.read(path))
    end
  end
end
