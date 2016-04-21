class AmazonGameGrazer < AmazonGrazer

  def self.top_url
    'http://www.amazon.co.uk/gp/new-releases/videogames/ref=sv_vg_h__13'
  end

  def self.get_summary_data(limit=0)
    summary_data = []
    section_links.each do |section_link|
      summary_data += process_section(section_link)
    end
    summary_data
  end

  # FIXME: Platform not working
  def self.get_platform(page)
    platform = look_for_format(page) || look_for_selectable_format(page)
    extract_platform(platform)
  end

  def self.get_description(page)
    target = page.at('.content .productDescriptionWrapper') ||
             page.at('.apm-sidemodule-textright')
    target.text.strip if target
  end

  def self.selector # TODO: These selectors are for summaries; add that to the names
    AmazonGamesSelector
  end

  protected

  class AmazonGamesSelector
    SELECTORS = {
        item:         '.s-item-container',
        next_link:    'a#pagnNextLink',
        url:          '.zg_itemImageImmersion a',
        price:        '.price',
        release_date: '.zg_releaseDate',
        title:        '.zg_title',
        image:        '.zg_itemImageImmersion a img'
    }

    def self.set_item(item) ; @item = item end

    def self.url   ; @item.css(SELECTORS[:url]).attr('href').value  end
    def self.price ; @item.css(SELECTORS[:price]).try(:text)        end
    def self.asin  ; url[/\/dp\/(\w{10})\//, 1]                     end
    def self.title ; @item.css(SELECTORS[:title]).text              end
    def self.image ; @item.css(SELECTORS[:image]).attr('src').value end
    def self.release_date
      if @item.css(SELECTORS[:release_date])
        @item.css(SELECTORS[:release_date]).text[/\d{1,2} [A-Za-z]{2,9} \d{4}/]
      end
    end
  end

  private

  # Extract the platform/format from a drop-down list
  def self.look_for_selectable_format(page)
    found = page.at('#selected_platform_for_display b.variationLabel')
    found.text if found
  end

  # Extract the platform/format from a simple div
  def self.look_for_format(page)
    found = page.at('#platformInformation_feature_div')
    found = found.text.strip if found
    found[/\APlatform ?:\W*([\w ]+\w)\z/, 1] if found
  end

  # Scan for section URLs (3DS, PS4 etc) and return in an array
  def self.section_links
    get_page(top_url)
      .search('ul#zg_browseRoot ul ul li a')
      .select { |a| a.text != 'Accessories' } # Skip this shite for now
      .map { |a| a.attr('href') }
  end

  # Extract the product data from each page in section
  # and return in an array
  def self.process_section(section_link)
    links = page_links_in_section(section_link)

    product_data = []
    links.each do |page|
      data = get_page_data(page)
      product_data += data if data
    end
    product_data
  end

  # Return an array of all page links in a section (1-20, 21-40, 41-60 etc)
  def self.page_links_in_section(section)
    get_page(section)
     .search('.zg_page a')
     .map { |a| a.attr('href') }
  end

  # Turn each product info div on the page into a hash of data
  # and return data in an array
  def self.get_page_data(page)
    get_page(page).search('.zg_itemImmersion').map do |product|
      extract_summary_data(product)
    end
  end

end