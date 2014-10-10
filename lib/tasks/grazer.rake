namespace :graze do

  desc 'Get and insert game data from Amazon'
  task amazon_games: :environment do
    grazer = AmazonGameGrazer
    store  = Store.find_by(name: 'Amazon')
    dept   = Department.find_by(name: 'Games')
    ItemCreator.new(grazer, store, dept)
  end

  desc 'Get and insert DVD data from Amazon'
  task amazon_dvds: :environment do
    grazer = AmazonDVDGrazer
    store  = Store.find_by(name: 'Amazon')
    dept   = Department.find_by(name: 'Video')
    ItemCreator.new(grazer, store, dept)
  end

  desc 'Get and insert Music data from Amazon'
    task amazon_music: :environment do
    grazer = AmazonMusicGrazer
    store  = Store.find_by(name: 'Amazon')
    dept   = Department.find_by(name: 'Music')
    ItemCreator.new(grazer, store, dept)
    end

  desc 'Get and insert DVD data from Play.com'
  task play_dvds: :environment do
    grazer = PlayDVDGrazer
    store  = Store.find_by(name: 'Play')
    dept   = Department.find_by(name: 'Video')
    ItemCreator.new(grazer, store, dept)
  end

  desc 'Get and insert music data from Play.com'
  task play_music: :environment do
    grazer = PlayMusicGrazer
    store  = Store.find_by(name: 'Play')
    dept   = Department.find_by(name: 'Music')
    ItemCreator.new(grazer, store, dept)
  end

  desc 'Get and insert game data from Play.com'
  task play_games: :environment do
    grazer = PlayGameGrazer
    store  = Store.find_by(name: 'Play')
    dept   = Department.find_by(name: 'Games')
    ItemCreator.new(grazer, store, dept)
  end

  desc 'Get and insert Music data from iTunes'
    task itunes_music: :environment do
    grazer = ItunesMusicChartGrazer
    store  = Store.find_by(name: 'iTunes')
    dept   = Department.find_by(name: 'Music')
    ItemCreator.new(grazer, store, dept)
  end

end

# This class can be put in a new file

class ItemCreator
  def initialize(grazer, store, dept)
    @grazer = grazer
    @store  = store
    @dept   = dept
    get_summaries
  end

  private

  def get_summaries
    puts 'Getting summaries...'
    data = @grazer.get_summary_data(3)   # TODO: Don't have this hard-coded limit
    puts "Found #{data.size} summaries."
    data.each { |item| process_item(item) }
  end

  def process_item(scraped_item)
    stored_product = Product.find_by(store_id: @store.id, asin: scraped_item[:asin])
    stored_product ?
      update_item(scraped_item, stored_product) :
      create_item(scraped_item)
  end

  def update_item(scraped_item, stored_product)
    puts "Updating '#{stored_product.item.title}'"

    new_values = scraped_item.slice(:price, :rank)
    stored_product.assign_attributes(new_values)
    stored_product.item.release_date = scraped_item.slice(:release_date)
  end

  def create_item(scraped_item)
    sleep 0.7
    puts "Creating record for '#{scraped_item[:title]}'"
    puts "    #{scraped_item[:url]}"

    full_data = @grazer.get_product_data(scraped_item[:url])

    item = get_item(full_data, scraped_item)

    attrs = full_data.slice(:url, :rank, :price, :asin)
    attrs.merge!(scraped_item.slice(:rank))
    attrs[:store_id] = @store.id

    item.products.build(attrs)
    item.description = full_data[:description] if full_data[:description] && item.description.nil?

    item.save!
  end

  def get_item(data, summary)
    platform_name = data[:platform] || summary[:platform]
    platform = Platform.find_by(name: platform_name)

    item = Item.where(platform: platform,
                      department: @dept,
                      variation: data[:variation])
               .where('LOWER(title) = ?', data[:title].downcase)
               .first

    if item.nil?
      attrs = data.slice(:title, :creator, :variation, :release_date)
      item = @dept.items.build(attrs)
      item.platform = platform
      item.image = data[:image]
    end

    item
  end

end