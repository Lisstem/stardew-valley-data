# frozen_string_literal: true

module StardewValley
  WIKI_URL = 'https://stardewcommunitywiki.com'
  SEASONS = %w[Spring Summer Fall Winter]


  def wiki_link(name)
    "#{WIKI_URL}/#{remove_slash(name.underscore)}"
  end

  def image_link(name)
    "#{WIKI_URL}/FILE:#{remove_slash(name.underscore)}.png"
  end

  def read_json(path)
    JSON.parse(File.read(path))
  end

  private

  def remove_slash(path)
    path.match(/\A\/+/) ? path.gsub(/\A\/+/, '') : path
  end
end
