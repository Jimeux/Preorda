class Department < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name

  has_many :platforms
  has_many :items,         -> { latest }
  has_many :preview_items, -> { latest_in_dept }, class_name: 'Item'

  default_scope -> { includes(:platforms).order('id ASC') }

  validates_uniqueness_of :name

  # Lowercase name required for CSS class names and such
  def name ; self[:name].downcase end

end