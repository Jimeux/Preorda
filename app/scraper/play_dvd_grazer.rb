class PlayDVDGrazer < PlayGrazer

  def self.section_url
    'http://www.play.com/DVD/DVD/6-/PreOrderChart.html'
  end

  def self.get_platform
    'DVD'
  end

end