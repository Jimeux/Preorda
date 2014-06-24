namespace :graze do

  desc 'Get games from Amazon'
  task amazon_games: :environment do
    grazer = AmazonGameGrazer
    store  = Store.find_by(name: 'Amazon')
    dept   = Department.find_by(name: 'Games')
    get_summaries(grazer, store, dept)
  end

  def get_summaries(grazer, store, dept)
    data = grazer.get_summary_data
    data.each { |item| process_item(item, dept, store) }
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

    full_data = AmazonGrazer.get_product_data(scraped_item[:url])

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