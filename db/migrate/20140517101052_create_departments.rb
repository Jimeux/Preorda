class CreateDepartments < ActiveRecord::Migration

  def change

    create_table :stores do |t|
      t.string  :name
    end

    create_table :departments do |t|
      t.string  :name
    end

    create_table :items do |t|
      t.string   :title
      t.references :department, index: true
      t.string   :creator      # Album artist, games company etc
      t.string   :platform
      t.string   :variation    # Usually null
      t.date     :release_date # Can be null when TBA

      t.timestamps
    end

    add_index :items, :platform, unique: false

    create_table :products do |t|
      t.text    :url
      t.decimal :price
      t.integer :rank
      t.references :item, index: true
      t.references :store, index: true

      # Use this for iTunes IDs or whatever other store too
      t.string  :asin     # Add unique, scope :store in the model

      t.timestamps
    end

  end

end