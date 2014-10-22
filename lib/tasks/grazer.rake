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

# This class can be put in a new file

class ItemCreator
  def initialize(grazer, store, dept, pages)
    #@linker = AffiliateLinker.new
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
    sleep 0.4
    puts "Creating record for '#{scraped_item[:title]}'"
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

    #attrs[:url] = @linker.get_affiliate_link(@store.name, attrs[:url])

    item.products.build(attrs)

    if full_data[:description] && item.description.nil?
      item.description = full_data[:description]
    end
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