class CreateDepartments < ActiveRecord::Migration

  def change

    create_table :stores do |t|
      t.string  :name
    end

    create_table :departments do |t|
      t.string  :name
    end

    create_table :releases do |t|
      t.string  :title
      t.integer :department_id
      t.string  :creator      # Album artist, games company etc
      t.string  :platform
      t.string  :variation    # Usually null
      t.date    :release_date # Can be null when TBA

      t.timestamps
    end

    add_index :releases, :platform, unique: false

    create_table :products do |t|
      t.text    :url
      t.decimal :price
      t.integer :rank
      t.integer :item_id
      t.integer :store_id

      # Use this for iTunes IDs or whatever other store too
      t.string  :asin     # Add unique, scope :store in the model

      t.timestamps
    end

  end

end