class PlayGrazer
  extend GrazerBase

  PLAY_URL = 'http://www.play.com'

  def self.get_product_data(url)
    page = get_page(url)
    {
        title:        extract_title(get_title(page), get_platform),
        platform:     get_platform,
        creator:      page.at('.nobox.pan p:contains("Artist")') ? page.at('.nobox.pan p:contains("Artist")').text[/Artist: (.*)/, 1] : nil,
        variation:    extract_variation(get_title(page), get_platform),
        image:        get_image(page),
        release_date: get_release_date(page),
        asin:         url[/\/(\d{8})\//, 1],
        price:        page.at('span.price').text.blank? ? nil : extract_price(page.at('span.price').text[/\d{1,2}\.?\d{2}?/]),
        url:          url,
        description:  page.at('#Description') ? page.at('#Description').text.strip : nil
    }
  end

  # These should be overridden where appropriate
  def self.get_platform ; nil end
  def self.section_url  ; nil end

  def self.get_image(page)
    if page.at('#zoom-link') && page.at('#zoom-link').text[/http/]
      page.at('#zoom-link').attr('href').strip
    elsif page.at('#main_product img')
      page.at('#main_product img').attr('src').strip
    else
      nil
    end
  end

  def self.get_title(page)
    title = page.at('.h1-product-page') || page.at('.product-overview h1')
    title.text
  end

  def self.get_release_date(page)
    release_date = page.at('#bodycontent_1_maincontent_0_ctl00_ctl00_productDetails_productTitle_ReleaseDate') ||
                   page.at('.nobox.pan p:contains("Released on")')
    release_date ? release_date.text[/Released on (.*)/, 1].strip : nil
  end

  def self.get_summary_data(limit=0)
    page_url = section_url  # Start on the first page
    summary_data = []

    limit.times do
      page = get_page(page_url)

      # Find all product divs and extract their data
      page.search('section.line.mt0 article.media').each do |p|
        summary_data << extract_summary_data(p)
      end

      # Set page_url to the next page before the next iteration of the loop
      # If no link is found, then we're finished
      next_link = page.at('.paging-arrow a')
      next_link ?
        page_url = URI.join(PLAY_URL, next_link.attr('href')).to_s :
        break
    end

    summary_data
  end

  def self.extract_summary_data(prod)
    url = URI.join(PLAY_URL, prod.at('.media-title a').attr('href')).to_s
    {
        url:          url,
        price:        prod.at('span.price') ? prod.at('span.price').text.squish.gsub(/[ £]/, '') : nil,
        release_date: prod.at('.release-date') ? prod.at('.release-date').text[/Released on (.*)/, 1] : nil,
        asin:         url[/\/(\d{8})\//, 1],
        title:        prod.at('.media-title').text.strip,
        image:        prod.at('.img img').attr('src'),
    }
  end

end