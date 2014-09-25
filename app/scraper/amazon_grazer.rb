class AmazonGrazer
  extend Grazer

  AMAZON_URL  = 'http://www.amazon.co.uk'

  # TODO: Once the ASIN is known the API can be used

  def self.get_product_data(url)
    page = get_page(url)
    {
      title:        extract_title(get_title(page)),
      platform:     get_platform(page),
      creator:      get_creator(page),
      variation:    get_variation(page),
      image:        get_image_url(page),
      release_date: get_release_date(page),
      asin:         url[/\/dp\/(\w{10})\//, 1],
      price:        get_price(page),
      url:          url
    }
  end

  def self.get_title(page)
    title = page.at('#btAsinTitle') || page.at('#productTitle')
    title.text
  end

  # This method attempts to standardise inconsistent platform names.
  # The default implementation cover Music and DVD

  def self.get_platform(page)
    found = page.search('div#byline')
    return found.text[/Format: ([\w ]+\w)/, 1] if found
  end

  # This is the games maker, album artist etc

  def self.get_creator(page)
    creator = page.at('.buying span a') || page.at('#brand') || page.at('.author a')
    creator.text if creator
  end

  def self.get_variation(page)
    page.search('.variationSelected') #TODO: Find and list all variation types below
      .select { |v| v.at('.variationDefault').text =~ /Edition|Colour/ && v.at('.variationLabel') }
      .map    { |v| v.at('.variationLabel').text }
      .join(', ')
  end

  def self.get_image_url(page)
    image = page.at('#main-image')          ||
            page.at('#imgTagWrapperId img') ||
            page.at('#landingImage')        ||
            page.at('.kib-image-ma')

    image.attr('data-old-hires').blank? ?
      image.attr('rel') || image.attr('src').gsub(/[\n ]/,'') :
      image.attr('data-old-hires')
  end

  def self.get_release_date(page)
    release_date = page.at('.availOrange') || page.at('#availability')
    release_date.text[/released on (.*)\./, 1] if release_date
  end

  def self.get_price(page)
    price = page.at('b.priceLarge') || page.at('#priceblock_ourprice')
    price ? price.text[/\d+\.+\d+/].to_d : 0
  end

end