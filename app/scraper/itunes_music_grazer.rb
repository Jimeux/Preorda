class ItunesMusicGrazer
  extend Grazer

  def self.section_url ; 'https://itunes.apple.com/gb/collection/pre-orders/id1?fcId=303241591' end
  def self.get_platform ; 'MP3 Download' end

  def self.get_product_data(url)
    page = get_page(url)
    page.at('li.expected-release-date span.label').remove
    {
        title:        extract_title(page.at('.title').text),
        platform:     get_platform,
        creator:      page.search('.header-breadcrumb li').last.text,
        variation:    check_variation(page.at('.title').text),
        image:        page.at('div.artwork img').attr('src-swap-high-dpi'),
        release_date: page.at('li.expected-release-date').text,
        asin:         page.at('div.multi-button button').attr('adam-id'),
        price:        extract_price(page.at('span.price').text),
        url:          url,
        description:  nil
    }
  end

  def self.check_variation(title)
    'Deluxe' if title.downcase[/\(deluxe\)/]
  end

  def self.get_summary_data(limit=1)
    agent.user_agent = 'iTunes/10.3.1 (Macintosh; Intel Mac OS X 10.6.8) AppleWebKit/533.21.1'

    page_url = section_url  # Start on the first page
    summary_data = []

    #limit.times do
      page = get_page(page_url)

      # Find all product divs and extract their data
      page.search('div.lockup.small.detailed.option').each do |p|
        summary_data << extract_summary_data(p)
      end

      # Set page_url to the next page before the next iteration of the loop
      # If no link is found, then we're finished
      #next_link = page.at('.paging-arrow a')
      #next_link ?
      #    page_url = URI.join(PLAY_URL, next_link.attr('href')).to_s :
      #    break
    #end

    summary_data
  end

  def self.extract_summary_data(prod)
    prod.at('li.expected-release-date span.label').remove
    {
      url:          prod.at('a.artwork-link').attr('href'),
      price:        extract_price(prod.at('span.price').text),
      release_date: prod.at('li.expected-release-date').text,
      asin:         prod.attr('adam-id'),
      title:        extract_title(prod.at('li.name').text),
      image:        prod.at('div.artwork img').attr('src-swap-high-dpi'),
      #artist: p.at('li.artist').text,
    }
  end
end