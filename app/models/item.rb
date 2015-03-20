class Item < ActiveRecord::Base
  extend FriendlyId

  # --- FriendlyID Settings ---#

  friendly_id :slug_candidates, use: :slugged

  #def should_generate_new_friendly_id? ; true end

  def slug_candidates
    if variation.nil?
      [ :title,
        [:title, :platform_id]
      ]
    else
      [ [:title, :variation],
        :title
      ]
    end
  end

  # --- Associations ---#

  belongs_to  :department
  belongs_to  :platform
  has_many    :products, -> { order(:price) }, dependent: :destroy

  FRONT_PAGE_LIMIT = 6

  # --- Paperclip settings ---#           # TODO: Add a default image

  has_attached_file :image,
                    url:        '/system/:class/:id/:style/image.:extension',
                    styles: ->(attachment) {
                          { show: '450x',
                        thumb: attachment.instance.set_image_styles }
                    },
                    convert_options: {
                        all: '-rotate 270 -strip -interlace Plane -quality 80%'
                    },
                    default_url: '/images/:style/missing.png' #,
                    #use_timestamp: false
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def set_image_styles
    case department.name.downcase
      when 'music' then '130x130#'   # 1    ratio
      when 'games' then '125x155#'   # 1.25 ratio
      else '125x175#'                # 1.4  ratio
    end
  end

  # --- Scopes ---#

  scope :latest, -> {
    #.includes(:platform)
    includes(:products)
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

  scope :latest_page, ->(dept_id, page) {
    includes(:department)
    .includes(:products)
    .select('DISTINCT ON(items.title, items.release_date) *')
    .where(department_id: dept_id)
    .where('items.release_date > now() OR items.release_date IS NULL')
    .order('items.release_date, items.title')
    .paginate(page: page, per_page: FRONT_PAGE_LIMIT)
  }

  # --- Model methods ---#

  def lowest_price
    products.first.price || 0
  end

  # Returns one product per store
  def list_products
    products.to_a.uniq(&:store_id)
  end

end