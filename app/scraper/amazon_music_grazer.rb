class AmazonMusicGrazer < AmazonGrazer

  MUSIC_TOP_URL = 'http://www.amazon.co.uk/s/ref=sr_ex_p_n_feature_four_bro_0?rh=n%3A229816%2Cp_69%3A1y-90y%2Cp_n_binding_browse-bin%3A382528011%2Cp_n_binding_browse-bin%3A382532011&bbn=229816&ie=UTF8&qid=1411630013'

  def self.get_summary_data(limit)
    page_url = MUSIC_TOP_URL  # Start on the first page
    summary_data = []

    limit.times do   # Put in a limit for now to avoid too many requests

      # Get a Mechanize object for the URL

      page = get_page(page_url)

      # Find all product divs and extract their data

      page.search('.prod').each do |p|
        summary_data << extract_summary_data(p)
      end

      # Set page_url to the next page before the next iteration of the loop
      # If no link is found, then we're finished

      next_link = page.at('a#pagnNextLink')

      if next_link
        # Join the relative URL with the Amazon domain
        page_url = URI.join(AMAZON_URL, next_link.attr('href')).to_s
      else
        break
      end

    end

    summary_data
  end

  def self.extract_summary_data(prod)
    url = prod.css('h3 a').attr('href').value
    {
        rank:         prod.attr('id')[/\d+/].to_i + 1,
        url:          url,
        price:        extract_price(prod.css('li.newp span.bld.lrg.red').text),
        release_date: prod.css('li span.grey.sml').text[/\d{1,2} [A-Za-z]{2,9} \d{4}/],
        asin:         url[/\/dp\/(\w{10})\//, 1],
        title:        prod.css('h3 a').text,
        image:        prod.css('.image.imageContainer img').attr('src')
    }
  end

end