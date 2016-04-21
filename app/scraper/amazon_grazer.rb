class AmazonGrazer
  extend GrazerBase

  AMAZON_URL  = 'http://www.amazon.co.uk'

  # TODO: Once the ASIN is known the API can be used

  def self.get_product_data(url)
    page = get_page(url)
    puts "Platform: #{get_platform(page)}"
    {
      title:        extract_title(get_title(page)),
      platform:     get_platform(page),
      creator:      get_creator(page),
      variation:    get_variation(page),
      image:        get_image_url(page),
      release_date: get_release_date(page),
      asin:         url[/\/dp\/(\w{10})\//, 1],
      price:        get_price(page),
      url:          url,
      description: get_description(page)
    }
  end

  def self.get_description(page) ; nil end

  def self.get_title(page)
    title = page.at('#btAsinTitle') || page.at('#productTitle')
    title.text
  end

  def self.get_platform(page)
    found = page.search('div#byline')
    return found.text[/Format: ([\w ]+\w)/, 1] if found.present?
    found = page.search('#variation_platform_for_display span.selection')
    return found.text.strip if found.present?
    found = page.search('#platformInformation_feature_div')
    return found.text.strip.delete("\n")[/Platform ?: (.*)/, 1].strip if found.present?
  end

  def self.get_creator(page)
    creator = page.at('.buying span a') || page.at('#brand') || page.at('.author a')
    creator.text if creator
  end

  def self.get_variation(page) #TODO: Find and list all variation types below
    return 'Blu-Ray 3D' if get_title(page)[/Blu-ray 3D/i]

    variation = page.search('.variationSelected')
      .select { |v| v.at('.variationDefault').text =~ /Edition|Colour/ && v.at('.variationLabel') }
      .map    { |v| v.at('.variationLabel').text }
      .join(', ')

    if variation.blank? && page.at('.a-size-medium.a-color-secondary.a-text-normal')
      variation = page.at('.a-size-medium.a-color-secondary.a-text-normal').text
    end

    variation.present? ? variation.gsub(/,? ?Explicit Lyrics/, '') : nil
  end

  def self.get_image_url(page)
    image = page.at('#main-image')          ||
            page.at('#imgTagWrapperId img') ||
            page.at('#landingImage')        ||
            page.at('.kib-image-ma')

    if image.attr('data-old-hires').blank?
      image.attr('rel').blank? ?
          image.attr('src').gsub(/[\n ]/, '') :
          image.attr('rel')
    else
      image.attr('data-old-hires')
    end
  end

  def self.get_release_date(page)
    release_date = page.at('.availOrange') || page.at('#availability')
    release_date.text[/released on (.*)\./, 1] if release_date
  end

  def self.get_price(page)
    price = page.at('#priceblock_ourprice') || page.at('b.priceLarge')
    price ? price.text[/\d+\.+\d+/].to_d : 0
  end

  ##
  # Return an an object with a hash of CSS selectors
  # and methods to extract each summary value
  ##
  def self.selector
    raise NotImplementedError
  end

  def self.get_summary_data(limit)
    page_url = top_url
    summary_data = []

    limit.times do
      page = get_page(page_url)

      # Find all product divs and extract their data
      items = page.search(selector::SELECTORS[:item])
      items.each do |item|
        summary_data << extract_summary_data(item)
      end

      # Set page_url to the next page before the next iteration of the loop
      # If no link is found, then we're finished
      next_link = page.at(selector::SELECTORS[:next_link])

      if next_link
        page_url = URI.join(AMAZON_URL, next_link.attr('href')).to_s
      else
        break
      end

    end

    summary_data
  end

  def self.extract_summary_data(item)
    selector.set_item(item)
    {
        url:          selector.url.strip,
        price:        extract_price(selector.price),
        asin:         selector.asin,
        title:        selector.title,
        image:        selector.image,
        release_date: selector.release_date
    }
  end

end