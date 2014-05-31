class Item < ActiveRecord::Base
  belongs_to  :department
  has_many    :products

  FRONT_PAGE_LIMIT = 6

  # Paperclip settings
  has_attached_file :image, styles: { thumb: '100x100#' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :news, ->(platform) {
      select('DISTINCT ON(title, release_date) *')
      .where('release_date > now()')
      .where('platform LIKE ?', "%#{platform}%")
      .order('release_date, title')
      .limit(FRONT_PAGE_LIMIT)
  }

  scope :n3ds,  -> { news('3DS')    }
  scope :ps4,   -> { news('tation%') }
  scope :xbox1, -> { news('%box%')   }
end