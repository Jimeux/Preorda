class Product < ActiveRecord::Base

  belongs_to :store
  belongs_to :item

end