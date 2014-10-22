require 'uri'

class AffiliateLinker
  @affiliate

  def get_affiliate_link(store_name, url, link_id = nil)

    if @affiliate.nil? || @affiliate.name != store_name
      @affiliate = Store.find_by_name(store_name)
    end

    #find if url contains the store domain
    if url.include? @affiliate.domain
      url = process_affiliate_url_params(url, link_id)
    end

    #return url untouched if it doesn't contain the store domain
    url
  end

  def process_affiliate_url_params(url, link_id)
    if @affiliate.affiliate_url != nil
      final_url = @affiliate.affiliate_url
    else
      final_url = url
    end

    url_params = @affiliate.url_parameters

    url_param_string = ''

    url_params.each do |url_param|

      if url_param_string != ''
        url_param_string += '&'
      end

      url_param_string += url_param.name
      url_param_string += '='

      if url_param.value == '<product_website>'
        url_param_string += CGI::escape(url)
      elsif url_param.value == '<product_id>'
        #generate a random id for links without an id given
        url_param_string +=
            CGI::escape((link_id.nil?) ? SecureRandom.hex(4) : link_id)
      else
        url_param_string += url_param.value
      end

    end
    puts url_param_string

    contains_q_mark = final_url.include?('?')

    final_url += contains_q_mark ? '' : '?'

    ends_with_q_mark = final_url.ends_with?('?')
    ends_with_ampersand = final_url.ends_with?('&')

    (ends_with_q_mark || ends_with_ampersand) ?
        url_param_string : '&' + url_param_string
  end

end