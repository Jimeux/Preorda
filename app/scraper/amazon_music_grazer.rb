class AmazonMusicGrazer < AmazonGrazer

  def self.top_url
    'http://www.amazon.co.uk/s/ref=sr_ex_p_n_feature_four_bro_0?rh=n%3A229816%2Cp_69%3A1y-90y%2Cp_n_binding_browse-bin%3A382528011%2Cp_n_binding_browse-bin%3A382532011&bbn=229816&ie=UTF8&qid=1411630013'
  end

  def self.selector
    AmazonMusicSelector
  end

  protected

  class AmazonMusicSelector
    SELECTORS = {
        item:         '.s-item-container',
        next_link:    'a#pagnNextLink',
        url:          'a.a-link-normal.a-text-normal',
        price:        'span.s-price',
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