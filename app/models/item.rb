class Item < ActiveRecord::Base
  extend FriendlyId

  # FriendlyID Settings

  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    # TODO: Set this to something reasonable for production
    true
  end

  def slug_candidates
    [ :title, [:title, :platform], [:title, :platform, :variation] ]
  end

  belongs_to  :department
  belongs_to  :platform
  has_many    :products, dependent: :destroy

  FRONT_PAGE_LIMIT = 6

  # TODO: Find out about conditional resizing (square for music, rectangle for DVD)
  # -- Paperclip settings                                  # TODO: Add a default image
  has_attached_file :image, styles: { thumb: '95x130#' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :latest, -> {
    includes(:products)
    .select('DISTINCT ON(items.title, items.release_date) *')
    .where('items.release_date > now() OR items.release_date IS NULL')
    .order('items.release_date, items.title')
    .limit(FRONT_PAGE_LIMIT)
  }

  scope :latest_in_dept, -> {
    includes(:products)
    .where('items.release_date > now() OR items.release_date IS NULL')
    .order('items.release_date, items.title')
  }

  def lowest_price
    products.first.price  #TODO: Should actually be the lowest
  end

end