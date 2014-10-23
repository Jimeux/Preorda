class Platform < ActiveRecord::Base
  belongs_to :department

  validates_uniqueness_of :name, scope: :department_id
end
