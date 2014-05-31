class AmazonDVDGrazer < AmazonGrazer

  def get_summary_data(page, limit)
    page_url = @department.url
    summary_data = []

    limit.times do
      page = get_page(page_url)
      page.search('.prod').each do |p|
        summary_data << extract_summary_data(p)
      end

      next_link = page.at('a#pagnNextLink')
      next_link ? page_url = next_link.attr('href') : break
    end
    summary_data
  end

  def extract_summary_data(prod)
    url = prod.css('h3 a').attr('href').value
    {
        amazon_url:   url,
        asin:         url[/\/dp\/(\w{10})\//, 1],
        department:   @department.name,
        amazon_rank:  prod.attr('id')[/\d+/].to_i + 1,
        title:        prod.css('h3 a').text,
        amazon_price: extract_price(prod.css('li.newp span.bld.lrg.red').text),
        image_url:    prod.css('.image.imageContainer img').attr('src'),
        release_date: prod.css('li span.grey.sml').text[/\d{1,2} [A-Za-z]{2,9} \d{4}/]
    }
  end

end