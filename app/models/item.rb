require 'elasticsearch/model'

class Item < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  extend FriendlyId

  # FriendlyID Settings

  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    # TODO: Set this to something reasonable for production
    true
  end

  def slug_candidates       #TODO: Make this work
    [ :title, [:title, :platform], [:title, :platform, :variation] ]
  end

  belongs_to  :department
  belongs_to  :platform
  has_many    :products, -> { order(:price) }, dependent: :destroy

  FRONT_PAGE_LIMIT = 6


  # -- Paperclip settings                # TODO: Add a default image
  has_attached_file :image,
                    styles: ->(attachment) {
                      {
                        show: '450x',
                        thumb: attachment.instance.set_styles
                      }
                    },
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :latest, -> {
    includes(:products)
    .includes(:platform)
    .includes(:department)
    .select('DISTINCT ON(items.title, items.release_date) *')
    .where('items.release_date > now() OR items.release_date IS NULL')
    .order('items.release_date, items.title')
    .limit(FRONT_PAGE_LIMIT)
  }

  scope :latest_in_dept, -> {
    includes(:department)
    .includes(:products)
    .includes(:platform)
    .where('items.release_date > now() OR items.release_date IS NULL')
    .order('items.release_date, items.title')
  }

  def set_styles
    case department.name
      when 'Music' then '170x170#'   # 1    ratio
      when 'Games' then '170x210#'   # 1.25 ratio
      else '170x240#'                # 1.4  ratio
      end
  end

  def lowest_price
    products.first.price
  end

  def list_products
    products.to_a.uniq(&:store_id)
  end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
      indexes :creator, analyzer: 'english'
    end
  end

end

# Delete the previous Items index in Elasticsearch
Item.__elasticsearch__.client.indices.delete index: Item.index_name rescue nil

# Create the new index with the new mapping
Item.__elasticsearch__.client.indices.create index: Item.index_name,
  body: { settings: Item.settings.to_hash, mappings: Item.mappings.to_hash }

# Index all Item records from the DB to Elasticsearch
Item.import