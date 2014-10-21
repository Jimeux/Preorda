class PlayBlurayGrazer < PlayGrazer

  def self.section_url
    'http://www.play.com/DVD/Blu-ray/6-/PreOrderChart.html'
  end

  def self.get_platform
    'Blu-Ray'
  end

end