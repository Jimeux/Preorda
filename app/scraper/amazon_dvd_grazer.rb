class AmazonDVDGrazer < AmazonGrazer

  def self.top_url
    'http://www.amazon.co.uk/s/ref=s9_al_bw_srch?rh=n%3A283926%2Cp_69%3A1y-%2Cp_n_binding_browse-bin%3A383381011&page=1&bbn=283926&rw_html_to_wsrp=1&pf_rd_m=A3P5ROKL5A1OLE&pf_rd_s=center-3&pf_rd_r=1T98JGJZQWGH3QMR0GG0&pf_rd_t=101&pf_rd_p=509179087&pf_rd_i=573412'
  end

  # @Override
  def self.get_platform(page)
    'DVD'
  end

  def self.selector
    AmazonDVDSelector
  end

  protected

  class AmazonDVDSelector
    SELECTORS = {
        item:         '.s-item-container',
        next_link:    'a#pagnNextLink',
        url:          'a.a-link-normal.a-text-normal',
        price:        'span.priceblock_ourprice',
        release_date: 'span.a-size-small.a-color-secondary',
        title:        'h2.s-access-title',
        image:        'img.s-access-image'
    }

    def self.set_item(item) ; @item = item end

    def self.url   ; @item.css(SELECTORS[:url]).attr('href').value  end
    def self.price ; @item.css(SELECTORS[:price]).text              end
    def self.asin  ; url[/\/dp\/(\w{10})\//, 1]                     end
    def self.title ; @item.css(SELECTORS[:title]).text              end
    def self.image ; @item.css(SELECTORS[:image]).attr('src').value end
    def self.release_date
      @item.css(SELECTORS[:release_date]).text[/\d{1,2} [A-Za-z]{2,9} \d{4}/]
    end
  end
end


#SAVED_FILE_NAME = "amazon_dvds.html"
#FILE_PATH 			= File.join(File.dirname(__FILE__), SAVED_FILE_NAME)
#page = agent.get(File.join("file://", FILE_PATH))