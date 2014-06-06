class ItemsController < ApplicationController

  # This renders the current top page. I think we should have a
  # DepartmentController as the root with a summary of the
  # newest games, DVDs, music etc. Then this index action can
  # be used for a Show All type piece for each platform

  def index

    # We'd go through the departments from the DB instead of these

    platforms = ['Nintendo 3DS', 'PlayStation 4', 'Xbox One', 'PlayStation Vita']

    # This will run a separate query for each platform
    # and put the results in an array to be used in the view

    @items = platforms.reduce([]) do |array, platform|

      # This will push a two-element array with the platform name and
      # query results. I call them as category.first and category.last in the view

      array <<
        [
          platform,

          # includes is Rails' idea of a join. It runs a separate query
          # like SELECT * FROM products WHERE id IN (1,2,3,4,5)

          Item.includes(:products).newest_for(platform)
        ]

    end
  end

end