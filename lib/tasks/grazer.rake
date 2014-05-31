namespace :graze do

  desc 'Create stores'
  task create_stores: :environment do
    names = %w{ Amazon iTunes }
    names.each { |name| Store.create(name: name) }
  end

  desc 'Create departments'
  task create_depts: :environment do
    names = %w{ Games DVD Blu-Ray Music }
    names.each { |name| Department.create(name: name) }
  end

  desc 'Get games from Amazon'
  task amazon_games: :environment do

    # Fetch Store ID
    Store.all.each { |store| puts "#{store.name}\t\t#{store.id}" }
    id = STDIN.gets.strip
    store = Store.find_by(id: id)
    raise '*** Invalid store! ***' unless store

    # Fetch Department ID
    Department.all.each { |dept| puts "#{dept.name}\t\t#{dept.id}" }
    id = STDIN.gets.strip
    dept = Department.find_by(id: id)
    raise '*** Invalid department! ***' unless dept

    # Specify appropriate scraper class
    if store.name.downcase == 'amazon'
      grazer = AmazonGameGrazer if dept.name.downcase == 'games'
      grazer = AmazonDVDGrazer  if dept.name.downcase == 'dvd'
      grazer = AmazonDVDGrazer  if dept.name.downcase == 'blu-ray'
    end

    # Start scraping
    raise 'No grazer found' unless grazer
    get_summaries(grazer, store, dept)
  end

  def get_summaries(grazer, store, dept)
    data = grazer.get_summary_data
    data.each do |item|
      process_item(item, dept, store)
    end
  end

  def process_item(scraped_item, dept, store)
    stored_product = Product.find_by(store_id: store.id, asin: scraped_item[:asin])
    stored_product ?
      update_item(scraped_item, stored_product) :
      create_item(scraped_item, dept, store)
  end

  def update_item(scraped_item, stored_product)
    puts "Updating '#{stored_product.item.title}'"

    new_values = scraped_item.slice(:price, :rank)
    stored_product.assign_attributes(new_values)
    stored_product.item.release_date = scraped_item.slice(:release_date)
  end

  def create_item(scraped_item, dept, store)
    sleep 1
    puts "Creating record for '#{scraped_item[:title]}'"
    puts "    #{scraped_item[:url]}"

    # TODO: Using AmazonGrazer here makes the factory pointless
    full_data = AmazonGrazer.get_product_data(scraped_item[:url])

    # TODO: Standardise inconsistent platform names, e.g. PlayStation Playstation etc
    attrs = full_data.slice(:title, :creator, :platform, :variation, :release_date, :image)
    item = dept.items.build(attrs)

    attrs = full_data.slice(:url, :rank, :price, :asin)
    attrs.merge!(scraped_item.slice(:rank))
    attrs[:store_id] = store.id

    item.products.build(attrs)
    item.save
  end

end

#full_data(title, platform, creator, variation, image, release_date, asin, price, url)
#summary_data(rank, url, price, release_date, asin, title, image)