class ItemCreator
  def initialize(grazer, store, dept, pages)
    @grazer = grazer
    @store  = store
    @dept   = dept
    @pages  = pages
    get_summaries
  end

  private

  def get_summaries
    puts "Getting summaries from #{@pages} pages..."
    data = @grazer.get_summary_data(@pages)
    puts "Found #{data.size} summaries."

    data.each_with_index do |item, index|
      puts "Processing item ##{index}/#{data.size}"
      process_item(item)
    end
  end

  def process_item(scraped_item)
    stored_product = Product.find_by(store_id: @store.id, asin: scraped_item[:asin])
    stored_product ?
        update_item(scraped_item, stored_product) :
        create_item(scraped_item)
  end

  def update_item(scraped_item, stored_product)
    puts "\tUpdating '#{stored_product.item.title}'"
    new_values = scraped_item.slice(:price, :rank)
    stored_product.assign_attributes(new_values)
    stored_product.item.release_date = scraped_item.slice(:release_date)
  end

  def create_item(scraped_item)
    sleep 2
    puts "\tCreating record for '#{scraped_item[:title]}'"
    puts "    #{scraped_item[:url]}"

    full_data = @grazer.get_product_data(scraped_item[:url])

    item = get_item(full_data, scraped_item)

    build_product(item, scraped_item, full_data)

    item.save!
  end

  def build_product(item, scraped_item, full_data)
    attrs = full_data.slice(:url, :rank, :price, :asin)
    attrs.merge!(scraped_item.slice(:rank))
    attrs[:store_id] = @store.id

    item.products.build(attrs)

    if full_data[:description] && item.description.nil?
      item.description = full_data[:description]
    end
  end

  def get_item(data, summary)
    platform_name = data[:platform] || summary[:platform]
    platform = Platform.find_by(name: platform_name)

    # Convert 'Family Guy - Season 14' to 'familyguyseason14'
    where_query = data[:title].downcase.gsub(/[\.\- ]/, '')

    item = Item.where(platform: platform, department: @dept, variation: data[:variation])
               .where("lower(translate(items.title, '.- ', '')) = ?", where_query)
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