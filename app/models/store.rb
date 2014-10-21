class Store < ActiveRecord::Base
  has_many :products
  has_many :url_parameters

  default_scope -> { includes(:url_parameters).order('id ASC') }
end