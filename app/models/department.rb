class Department < ActiveRecord::Base

  has_many :items

  # TODO: Currently hitting the DB for every Item record
  #       Find some way to limit each set of Items to 6 or so

  scope :latest_items, -> { includes(items: :products)
                            .where('release_date > now()')
                            .order('items.release_date') }
end