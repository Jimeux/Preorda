# Create stores
names = %w{ Amazon Play }
names.each { |name| Store.create(name: name) }

# Create departments
names = %w{ Music Video Games }
names.each { |name| Department.create(name: name) }

# Create platforms
game_platforms = ['Nintendo 3DS', 'Nintendo 2DS',
                  'Nintendo DS', 'Nintendo Wii',
                  'Nintendo Wii U', 'PlayStation 3',
                  'PlayStation Vita', 'PlayStation 4',
                  'Xbox One', 'Xbox 360', 'PC']
game_department = Department.find_by(name: 'Games')
game_platforms.each do |platform|
  Platform.create(department: game_department, name: platform)
end

video_platforms = %w(DVD Blu-Ray)
video_department = Department.find_by(name: 'Video')
video_platforms.each do |platform|
  Platform.create(department: video_department, name: platform)
end

music_platforms = ['Audio CD']
music_department = Department.find_by(name: 'Music')
music_platforms.each do |platform|
  Platform.create(department: music_department, name: platform)
end