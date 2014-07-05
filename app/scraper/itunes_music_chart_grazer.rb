class ItunesMusicChartGrazer < ItunesChartGrazer
  extend Grazer

  MUSIC_URL_PATH = "albums/"

  def self.get_summary_data(limit = nil)

    puts "getting summary data"
    page_url = ITUNES_CHARTS_URL + MUSIC_URL_PATH  # Start on the first page
    summary_data = []

    page = get_page(page_url)

    # Find all album li's and extract their data

    page.search('.grid ul li').each do |p|
      summary_data << extract_summary_data(p)
    end

=begin
    albums = page.search('.grid ul li')

    for i in 0..2
      summary_data << extract_summary_data(albums[i])
    end
=end

    puts "returning summary data "

    summary_data

  end

  def self.extract_summary_data(prod)

    url = prod.css('a')[0].attr('href')

    price_and_release = get_price_and_release(url)

    summary_data = {
        rank:         prod.css('strong').text[/\d+/].to_i,
        url:          url,
        price:        price_and_release[:price],
        release_date: price_and_release[:release],
        asin:         url[/id\d{8,9}\?/][/\d{8,9}/],
        title:        prod.css('h3 a').text,
        image:        prod.css('a img').attr('src').value
    }

    puts summary_data
    return summary_data
  end


  def self.get_price_and_release(page_url)
    page = get_page(page_url)

    product_info = page.at('div#left-stack div.product ul.list')

    release_date = product_info.css('.release-date').text[/[0-9]{1,2}\s{1}[a-zA-Z]{3,9}\s{1}[12]{1}[0-9]{3}/]
    release_date = (release_date.nil?)? product_info.css('.release-date').text[/[12]{1}[0-9]{3}/] : release_date
    release_date = ( release_date.nil? )?
        product_info.css('.expected-release-date').text[/[0-9]{1,2}\s{1}[a-zA-Z]{3,9}\s{1}[12]{1}[0-9]{3}/]
        : release_date

    price_and_release =
    {
        price: extract_price(product_info.css('span.price').text),
        release_date: release_date
    }
    #puts "£#{price_and_release[:price].to_s} released on '#{price_and_release[:release_date]}'"
  end

  def self.get_product_data(url)

    puts "getting product data"

    #this is all sloppy. Pretty much just rushed this whole bit
    page = get_page(url)

    title_and_artist = get_title_and_artist(page)

    product_info = page.at('div#left-stack div.product ul.list')
    release_date = product_info.css('.release-date').text[/[0-9]{1,2}\s{1}[a-zA-Z]{3,9}\s{1}[12]{1}[0-9]{3}/]
    release_date = (release_date.nil?)? product_info.css('.release-date').text[/[12]{1}[0-9]{3}/] : release_date
    release_date = ( release_date.nil? )?
        product_info.css('.expected-release-date').text[/[0-9]{1,2}\s{1}[a-zA-Z]{3,9}\s{1}[12]{1}[0-9]{3}/]
    : release_date


    {
        title:        title_and_artist[:title],
        platform:     "iTunes",
        creator:      title_and_artist[:creator],
        variation:    'Album',
        image:        page.at('div#left-stack div.product a div.artwork img.artwork').attr('src'),
        release_date: release_date,
        asin:         url[/id\d{8,9}\?/][/\d{8,9}/],
        price:        extract_price(product_info.css('span.price').text),
        url:          url
    }
  end

  def self.get_title_and_artist(page)

    title_div = page.at('div.padder div#title div.left')

    {
        title: title_div.css('h1').text,
        creator: title_div.css('h2 a').text
    }

  end

#  private :get_price_and_release
end