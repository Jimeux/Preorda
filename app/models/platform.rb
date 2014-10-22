class Platform < ActiveRecord::Base
  belongs_to :department

  validates_uniqueness_of :name
end
