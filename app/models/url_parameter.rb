class UrlParameter < ActiveRecord::Base
  belongs_to :store

  validates_uniqueness_of :name, scope: :store_id
end
