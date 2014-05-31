class AmazonGrazer
  extend Grazer

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

  private

  def self.get_title(page)
    title = page.at('#btAsinTitle') || page.at('#productTitle')
    title.text
  end

  def self.get_platform(page)
    # Games with selectable formats
    found = page.at('#selected_platform_for_display b.variationLabel')
    return found.text if found

    # Games without selectable formats
    found = page.at('#platform-information')
    return found.text[/Platform: ([\w ]+\w)/, 1] if found

    # Music & DVD     TODO: Move this into the appropriate class
    found = page.search('div.buying')
    return found.text[/Format: ([\w ]+\w)/, 1] if found
  end

  def self.get_creator(page)
    creator = page.at('.buying span a') || page.at('#brand')
    creator.text
  end

  def self.get_variation(page)
    page.search('.variationSelected') #TODO: Find and list all variation types below
      .select { |v| v.at('.variationDefault').text =~ /Edition|Colour/ && v.at('.variationLabel') }
      .map    { |v| v.at('.variationLabel').text }
      .join(', ')
  end

  def self.get_image_url(page)
    image = page.at('#main-image') || page.at('#imgTagWrapperId img')
    image.attr('src')
  end

  def self.get_release_date(page)
    if page.at('.availOrange')
      page.at('.availOrange').text[/released on (.*)\./, 1]
    end # Unavailable CSS - '#availability_feature_div .availRed'
  end

  def self.get_price(page)
    page.at('b.priceLarge') ?
      extract_price(page.at('b.priceLarge').text) : 0
  end

end