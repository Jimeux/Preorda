class AddDomainToStore < ActiveRecord::Migration
  def change
    add_column :stores, :domain, :string
  end
end
