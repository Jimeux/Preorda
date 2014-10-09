class PlayGameGrazer < PlayGrazer

  def self.section_url
    'http://www.play.com/Games/Games/6-/PreOrderChart.html'
  end

  def self.extract_summary_data(prod)
    hash = super(prod)
    hash[:platform] = prod.at('.bd .sub-title') ?
        extract_platform(prod.at('.bd .sub-title').text.strip) :
        nil
    hash
  end

end