class AmazonBlurayGrazer < AmazonDVDGrazer

  def self.top_url
    'http://www.amazon.co.uk/s/ref=amb_link_180925227_9?ie=UTF8&bbn=283926&rh=i%3Advd%2Cn%3A283926%2Cp_69%3A1y-%2Cp_6%3AA3P5ROKL5A1OLE%2Cp_74%3A0-99999900%2Cp_n_binding_browse-bin%3A383380011&pf_rd_m=A3P5ROKL5A1OLE&pf_rd_s=center-2&pf_rd_r=1DP8DETKB6SECYAAJ905&pf_rd_t=101&pf_rd_p=484535407&pf_rd_i=573412'
  end

  # @Override
  def self.get_platform(page)
    'Blu-Ray'
  end

end