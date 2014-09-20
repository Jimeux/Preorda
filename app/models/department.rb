class Department < ActiveRecord::Base

  has_many :platforms
  has_many :items, -> { latest }
  has_many :preview_items, -> { latest_in_dept }, class_name: 'Item'

  def to_param
    "#{id} #{name.downcase}".parameterize
  end

end