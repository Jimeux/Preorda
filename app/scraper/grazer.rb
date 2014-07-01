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
    text.gsub(/\[.+\]|\(.+\)/, '').strip
  end

end