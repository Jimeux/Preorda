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
    affiliate_window_setup(params)

    uri.query = URI.encode_www_form(params) unless params.empty?
    uri.to_s
  end

  def affiliate_window_setup(params)
    if params['<product_website>']
      params['<product_website>'] += CGI::escape(url)
    end

    if params['<product_id>']
      link_id = SecureRandom.hex(4) unless link_id
      params['<product_id>'] += CGI::escape(link_id)
    end
  end

end