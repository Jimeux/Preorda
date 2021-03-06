require 'mechanize'

module GrazerBase

  VARIATIONS = {
      deluxe: 'Deluxe Edition',
      limited: 'Limited Edition',
      collector: "Collector's Edition",
      bluray3d:  'Blu-Ray 3D'
  }

  MUSIC_PLATFORMS = {
      audio_cd:         'Audio CD',
      mp3_download:     'MP3 Download',
  }

  VIDEO_PLATFORMS = [
      'DVD', 'Blu-Ray', 'Blu Ray'
  ]

  GAME_PLATFORMS = [
      'Nintendo 3DS', 'Nintendo 2DS', 'Nintendo DS', 'Nintendo Wii', 'Nintendo Wii U',
      'PlayStation 3', 'PS3', 'PS 3',
      'PlayStation Vita',
      'PlayStation 4', 'PS4', 'PS 4',
      'Xbox One', 'Xbox 360', 'PC & Mac'
  ]

  # Cache an instance of Mechanize for retrieving web pages
  def agent
    @agent ||= Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  # Return a Nokogiri instance for the page at the given URI
  def get_page(uri)
    agent.get(URI(uri))
  end

  # Remove currency and convert to decimal
  def extract_price(text)
    text.gsub('£', '').to_d
  end

  def extract_title(text, platform=nil)
    # Remove [DVD], (XBox) etc
    title = text.gsub(/\[.+\]|\(.+\)/, '').gsub(': ', ' - ').strip
    GAME_PLATFORMS.each         { |p| title.gsub!(/#{p}(?! console)/i, '') }
    VIDEO_PLATFORMS.each        { |p| title.gsub!(/#{p}/i, '') }
    MUSIC_PLATFORMS.values.each { |p| title.gsub!(/#{p}/i, '') }
    VARIATIONS.values.each      { |p| title.gsub!(/#{p}/i, '') }
    if platform == 'Blu-Ray'
      title.gsub!(/ 3D$/, '')
    end
    title
  end

  def extract_variation(text, platform=nil)
    return VARIATIONS[:deluxe]   if text =~ /delux/i
    return VARIATIONS[:limited]  if text =~ /limited ed/i
    if platform == 'Blu-Ray'
      VARIATIONS[:bluray3d] if text =~ /blu-ray 3d|blu ?ray 3d| 3D$/i
    end
  end

  def extract_platform(platform)
    return if platform.nil?

    case platform.downcase.delete(' ')
      when /nintendo3ds|3ds/               then return 'Nintendo 3DS'
      when /2ds|nintendo2ds/               then return 'Nintendo 2DS'
      when /ds|nintendods/                 then return 'Nintendo DS'
      when 'nintendowii'                   then return 'Nintendo Wii'
      when /wiiu|nintendowiiu/             then return 'Nintendo Wii U'
      when /playstation3|ps3/              then return 'PlayStation 3'
      when /psvita|playstationvita/        then return 'PlayStation Vita'
      when /playstation4|ps4/              then return 'PlayStation 4'
      when 'xboxone'                       then return 'Xbox One'
      when 'xbox360'                       then return 'Xbox 360'
      when /windows|pc|pcgames|macosx|mac/ then return 'PC & Mac'
      else puts 'Could not extract a platform.'
    end
  end

end