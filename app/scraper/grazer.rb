require 'mechanize'

module Grazer

  # Cache an instance of Mechanize for retrieving web pages
  def agent
    @agent ||= Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  # Return a Nokogiri instance for the page at the given URI
  def get_page(uri)
    agent.get(URI(uri))
  end

  # Remove currency and convert to decimal
  def extract_price(text)
    text.gsub('£', '').to_d
  end

  # Remove [DVD], (XBox) etc from title string
  def extract_title(text)
    text.gsub(/\[.+\]|\(.+\)/, '').gsub(': ', ' - ').strip
  end

  def extract_platform(platform)
    return if platform.nil?

    case platform.downcase.delete(' ')
      when /nintendo3ds|3ds/        then return 'Nintendo 3DS'
      when /2ds|nintendo2ds/        then return 'Nintendo 2DS'
      when /ds|nintendods/          then return 'Nintendo DS'
      when 'nintendowii'            then return 'Nintendo Wii'
      when /wiiu|nintendowiiu/      then return 'Nintendo Wii U'
      when 'playstation3'           then return 'PlayStation 3'
      when /psvita|playstationvita/ then return 'PlayStation Vita'
      when 'playstation4'           then return 'PlayStation 4'
      when 'xboxone'                then return 'Xbox One'
      when 'xbox360'                then return 'Xbox 360'
      when /windows|pc|pcgames/     then return 'PC'
      else puts 'Could not extract a platform.'
    end
  end

end