class ChangePlatformFormatInItem < ActiveRecord::Migration
  def change
    remove_column :items, :platform
    add_reference :items, :platform, index: true
  end
end
