require 'resolv-replace.rb'

namespace :graze do

  desc 'Graze items using these args: s=store d=dept p=pages'
  task items: :environment do
    store_name = (ENV['s'] || ENV['store']).downcase
    dept_name  = (ENV['d'] || ENV['dept']).downcase
    pages      = (ENV['p'] || ENV['pages']).to_i
    #graze(store_name, dept_name, pages)
  end

  # Amazon convenience tasks
  task amazon_music:  :environment do ; graze('amazon', 'music', AmazonMusicGrazer)  end
  task amazon_games:  :environment do ; graze('amazon', 'games', AmazonGameGrazer)   end
  task amazon_dvds:   :environment do ; graze('amazon', 'video', AmazonDVDGrazer)    end
  task amazon_bluray: :environment do ; graze('amazon', 'video', AmazonBlurayGrazer) end

  # Play.com convenience tasks
  task play_music:    :environment do ; graze('play',   'music', PlayMusicGrazer)    end
  task play_games:    :environment do ; graze('play',   'games', PlayGameGrazer)     end
  task play_dvds:     :environment do ; graze('play',   'video', PlayDVDGrazer)      end
  task play_bluray:   :environment do ; graze('play',   'video', PlayBlurayGrazer)   end

  # iTunes convenience tasks
  task itunes_music:  :environment do ; graze('itunes', 'music', ItunesMusicGrazer)  end

  def graze(store_name, dept_name, grazer, pages=2)
    store  = Store.where('lower(name) = ?', store_name.downcase).first
    dept   = Department.where('lower(name) = ?', dept_name.downcase).first
    #grazer = get_grazer(store_name, dept_name)
    pages  = (ENV['p'] || ENV['pages']).to_i
    ItemCreator.new(grazer, store, dept, pages)
  end

  def get_grazer(store_name, dept_name)
    if store_name == 'amazon'
      return AmazonDVDGrazer   if dept_name == 'video'
      return AmazonGameGrazer  if dept_name == 'games'
      return AmazonMusicGrazer if dept_name == 'music'
    elsif store_name == 'play'
      return PlayDVDGrazer     if dept_name == 'video'
      return PlayGameGrazer    if dept_name == 'games'
      return PlayMusicGrazer   if dept_name == 'music'
    end
  end

end