class AddAffiliateToStore < ActiveRecord::Migration
  def change
    add_column :stores, :affiliate, :string
  end
end
