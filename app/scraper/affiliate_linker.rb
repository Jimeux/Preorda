require 'uri'

class AffiliateLinker
  @affiliate

  def getAffiliateLink(storeName, url, linkId = nil)

    if @affiliate.nil? || @affiliate.name != storeName
      @affiliate = Store.find_by_name(storeName)
    end

    #find if url contains the store domain
    if url.include? @affiliate.domain
      url = processAffiliateURLParams(url, linkId)
    end

    #return url untouched if it doesn't contain the store domain
    return url

  end

  def processAffiliateURLParams(url, linkId)

    finalUrl = nil

    if @affiliate.affiliate_url != nil
      finalUrl = @affiliate.affiliate_url
    else
      finalUrl = url
    end

    urlParams = @affiliate.url_parameters

    urlParamString = ''

    urlParams.each{ |urlParam|

      if urlParamString != ''
        urlParamString += '&'
      end

      urlParamString += urlParam.name
      urlParamString+= '='

      if urlParam.value == '<product_website>'
        urlParamString += CGI::escape(url)
      elsif urlParam.value == '<product_id>'
        #generate a random id for links without an id given
        urlParamString += CGI::escape( (linkId.nil?)? SecureRandom.hex(4) : linkId)
      else
        urlParamString += urlParam.value
      end

    }
    puts urlParamString

    containsQMark = finalUrl.include?('?')

    finalUrl += (containsQMark == true)? '': '?'

    endsWithQMark = finalUrl.ends_with?('?')
    endsWithAmpersand = finalUrl.ends_with?('&')

    finalUrl += (endsWithQMark == true || endsWithAmpersand == true)? urlParamString : '&'+urlParamString

    return finalUrl

  end

end