class AmazonDVDGrazer < AmazonGrazer

  def self.top_url
    'http://www.amazon.co.uk/s/ref=s9_al_bw_srch?rh=n%3A283926%2Cp_69%3A1y-%2Cp_n_binding_browse-bin%3A383381011&page=1&bbn=283926&rw_html_to_wsrp=1&pf_rd_m=A3P5ROKL5A1OLE&pf_rd_s=center-3&pf_rd_r=1T98JGJZQWGH3QMR0GG0&pf_rd_t=101&pf_rd_p=509179087&pf_rd_i=573412'
  end

  # @Override
  def self.get_platform(page)
    'DVD'
  end

  def self.get_summary_data(limit)
    page_url = top_url # Start on the first page
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