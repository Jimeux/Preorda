class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.references :item, unique: true,
      t.text       :image
    end
  end
end