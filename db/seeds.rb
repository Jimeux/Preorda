# Create stores
=begin
names = %w{ Amazon Play }
names.each { |name| Store.create(name: name) }
=end

store_records = [
                  {
                    :name => 'Amazon',
                    :domain => 'amazon.co.uk',
                    :affiliate => nil,
                    :affiliate_url => nil,
                    :url_params =>[{
                                       :name => 'tag',
                                       :value => 'launchbro-21',
                                   }]
                  },
                  {
                    :name => 'Play',
                    :domain => 'play.com',
                    :affiliate => nil,
                    :affiliate_url => nil,
                    :url_params =>[]
                  },
#Zavvi is just an example of an affiliate window style setup would need to get real id values
#clickrefs are typically a way of identifying a link you've created through the AWin dashboard (for analytical purposes)
#p is the url encoded URL to where you're linking
                  {
                      :name => 'Zavvi',
                      :domain => 'zavvi.com',
                      :affiliate => 'Affiliate Window',
                      :affiliate_url => 'http://www.awin1.com/cread.php?',
                      :url_params =>[{
                                      :name=> 'awinmid',
                                      :value => '1234'
                                     },
                                     {:name=>'awinaffid',:value=>'123456'},
                                     {:name=>'clickref',:value=>'<product_id>'},
                                     {:name=>'p',:value=>'<product_website>'}
                      ]
                  }
                ]

store_records.each { |store_record| Store.create(name: store_record[:name],
                                                domain: store_record[:domain],
                                                affiliate: store_record[:affiliate],
                                                affiliate_url: store_record[:affiliate_url])

                    store = Store.find_by_name(store_record[:name])

                    store_record[:url_params].each {|url_param|

                      UrlParameter.create(name: url_param[:name], value: url_param[:value], store: store)
                    }
                  }

# Create departments
names = %w{ music video games }
names.each { |name| Department.create(name: name) }

# Create platforms
game_platforms = ['Nintendo 3DS', 'Nintendo 2DS',
                  'Nintendo DS', 'Nintendo Wii',
                  'Nintendo Wii U', 'PlayStation 3',
                  'PlayStation Vita', 'PlayStation 4',
                  'Xbox One', 'Xbox 360', 'PC']
game_department = Department.find_by(name: 'games')
game_platforms.each do |platform|
  Platform.create(department: game_department, name: platform)
end

video_platforms = %w(DVD Blu-Ray)
video_department = Department.find_by(name: 'video')
video_platforms.each do |platform|
  Platform.create(department: video_department, name: platform)
end

music_platforms = ['Audio CD']
music_department = Department.find_by(name: 'music')
music_platforms.each do |platform|
  Platform.create(department: music_department, name: platform)
end

