class Feature < ActiveRecord::Base

  belongs_to :item

  has_attached_file :image, styles: { original: '480x215#' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :image
  validates_uniqueness_of :item_id

end
