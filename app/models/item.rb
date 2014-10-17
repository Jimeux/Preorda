class Item < ActiveRecord::Base
  extend FriendlyId

  # --- FriendlyID Settings ---#

  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    # TODO: Set this to something reasonable for production
    true
  end

  def slug_candidates       #TODO: Make this work
    [ :title, [:title, :platform], [:title, :platform, :variation] ]
  end

  # --- Associations ---#

  belongs_to  :department
  belongs_to  :platform
  has_many    :products, -> { order(:price) }, dependent: :destroy

  FRONT_PAGE_LIMIT = 6


  # --- Paperclip settings ---#           # TODO: Add a default image

  has_attached_file :image,
                    styles: ->(attachment) {
                      { show: '450x',
                        thumb: attachment.instance.set_image_styles }
                    },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def set_image_styles
    case department.name
      when 'Music' then '170x170#'   # 1    ratio
      when 'Games' then '170x210#'   # 1.25 ratio
      else '170x240#'                # 1.4  ratio
    end
  end

  # --- Scopes ---#

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

  # --- Model methods ---#

  def lowest_price
    products.first.price
  end

  # Returns one product per store
  def list_products
    products.to_a.uniq(&:store_id)
  end

end