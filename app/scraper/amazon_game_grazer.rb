class AmazonGameGrazer
  extend Grazer

  @top_url = 'http://www.amazon.co.uk/gp/new-releases/videogames/ref=sv_vg_h__13'

  def self.get_summary_data
    summary_data = []
    section_links.each do |section_link|
      summary_data += process_section(section_link)
    end
    summary_data
  end

  # Scan for section URLs (3DS, PS4 etc) and return in an array
  def self.section_links
    get_page(@top_url)
      .search('ul#zg_browseRoot ul ul li a')
      .map { |a| a.attr('href') }
  end

  # Extract the product data from each page in section
  # and return in an array
  def self.process_section(section_link)
    links = page_links_in_section(section_link)

    product_data = []
    links.each { |page| product_data += get_page_data(page) }
    product_data
  end

  # Return an array of all page links in a section (1-20, 21-40, 41-60 etc)
  def self.page_links_in_section(section)
    get_page(section)
     .search('.zg_page a')
     .map { |a| a.attr('href') }
  end

  # Turn each product info div on the page into a hash of data
  # and return data in an array
  def self.get_page_data(page)
    get_page(page).search('.zg_itemImmersion').map do |product|
      extract_summary_data(product)
    end
  end

  def self.extract_summary_data(prod)
    url = prod.css('.zg_itemImageImmersion a').attr('href').value.strip
    {
      rank:         prod.css('span.zg_rankNumber').text[/\d{1,3}/].to_i,
      url:          url,
      price:        get_price(prod),
      release_date: get_release_date(prod),
      asin:         url[/\/dp\/(\w{10})\//, 1], # TODO: Remove duplication
      title:        extract_title(prod.css('.zg_title').text),
      image:        prod.css('.zg_itemImageImmersion a img').attr('src').value
    }
  end

  def self.get_price(prod)
    prod.css('.price') ? extract_price(prod.css('.price').text) : 0
  end

  def self.get_release_date(prod)
    if prod.css('.zg_releaseDate')
      date = prod.css('.zg_releaseDate').text[/\d{1,2} [A-Za-z]{2,9} \d{4}/]
      Date.parse(date) if date
    end
  end
end