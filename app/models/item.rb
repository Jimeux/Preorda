class Item < ActiveRecord::Base
  belongs_to  :department
  has_many    :products, dependent: :destroy

  FRONT_PAGE_LIMIT = 6

  # Paperclip settings
  has_attached_file :image, styles: { thumb: '100x100#' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :newest_for, ->(platform) {
      select('DISTINCT ON(title, release_date) *')
      .where('release_date > now()')
      .where('platform = ?', platform)
      .order('release_date, title')
      .limit(FRONT_PAGE_LIMIT)
  }

end