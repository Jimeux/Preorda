class AddAffiliateUrlToStore < ActiveRecord::Migration
  def change
    add_column :stores, :affiliate_url, :string
  end
end
