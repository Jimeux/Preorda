class Department < ActiveRecord::Base
  has_many :items
end