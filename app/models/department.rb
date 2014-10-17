class Department < ActiveRecord::Base

  has_many :platforms
  has_many :items,         -> { latest }
  has_many :preview_items, -> { latest_in_dept }, class_name: 'Item'

  default_scope -> { includes(:platforms).order('id ASC') }

  def to_param # TODO: temporary pretty URL solution. Renders: /1-games/
    "#{id} #{name.downcase}".parameterize
  end

  # Lowercase name required for CSS class names and such
  def name ; self[:name].downcase end

end