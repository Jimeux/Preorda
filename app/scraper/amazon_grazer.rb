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

  # Extract the platform/format from a drop-down list

  def self.look_for_selectable_format(page)
    found = page.at('#selected_platform_for_display b.variationLabel')
    found.text.downcase.delete(' ') if found
  end

  # Extract the platform/format from a simple div

  def self.look_for_format(page)
    found = page.at('#platform-information')
    found.text[/Platform: ([\w ]+\w)/, 1].downcase.delete(' ') if found
  end

  # Platform names can be inconsistent like Playstation4 or PlayStation 4
  # This method attempts to standardise them

  def self.get_platform(page)

    # Music & DVD

    found = page.search('div.buying')
    return found.text[/Format: ([\w ]+\w)/, 1] if found

    # Games

    platform = look_for_format(page) || look_for_selectable_format(page)

    case platform
      when 'nintendo3ds'     then return 'Nintendo 3DS'
      when 'nintendo2ds'     then return 'Nintendo 2DS'
      when 'nintendods'      then return 'Nintendo DS'
      when 'nintendowii'     then return 'Nintendo Wii'
      when 'nintendowiiu'    then return 'Nintendo Wii U'
      when 'playstation3'    then return 'PlayStation 3'
      when 'playstationvita' then return 'PlayStation Vita'
      when 'playstation4'    then return 'PlayStation 4'
      when 'xboxone'         then return 'Xbox One'
      when 'xbox360'         then return 'Xbox 360'
      when /windows|pc/      then return 'PC'
      else puts 'Could not extract a platform.'
    end
  end

  # This is the games maker, album artist etc

  def self.get_creator(page)
    creator = page.at('.buying span a') || page.at('#brand')
    creator.text if creator
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