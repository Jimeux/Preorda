class PlayMusicGrazer < PlayGrazer

  def self.section_url
    'http://www.play.com/Music/CD/6-/PreOrderChart.html'
  end

  def self.get_platform
    'Audio CD'
  end

  def self.get_product_data(url)
    data = super(url)
    data[:title] = data[:title].sub(
        / ?-? ?#{Regexp.escape(data[:creator])} ?-? ?/, '')
    data
  end

end