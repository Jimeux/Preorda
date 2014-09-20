class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.references :department, index: true
      t.string :name

      t.timestamps
    end
  end
end
