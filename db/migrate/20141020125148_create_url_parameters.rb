class CreateUrlParameters < ActiveRecord::Migration
  def change
    create_table :url_parameters do |t|
      t.string :name
      t.string :value
      t.references :store, index: true

      t.timestamps
    end
  end
end
