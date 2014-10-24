class Platform < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :department

  default_scope { order('name DESC') }

  validates_uniqueness_of :name, scope: :department_id
end
