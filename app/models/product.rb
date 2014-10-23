class Product < ActiveRecord::Base

  belongs_to :store
  belongs_to :item

  def url
    if self[:url].include?(store.domain)
      process_affiliate_params(self[:url])
    else
      self[:url]
    end
  end

  private

  def process_affiliate_params(url)
    uri = URI.parse(url)

    existing_params  = uri.query ? URI.decode_www_form(uri.query) : []
    affiliate_params = store.url_parameters.pluck(:name, :value)
    params = (existing_params + affiliate_params).to_h

    uri.query = URI.encode_www_form(params) unless params.empty?
    uri.to_s
  end

  # This method will take a URL like http://store.com/product
  # and return http://affiliate.com?referrer=http://store.com/product
  def affiliate_window_setup(uri, params)
    product_website = params.key('<product_website>')
    params[product_website] = CGI::escape(url) if product_website

    product_id = params.key('<product_id>')
    if product_id
      link_id = SecureRandom.hex(4) unless link_id
      params[product_id] = CGI::escape(link_id)
    end

    uri
  end

end