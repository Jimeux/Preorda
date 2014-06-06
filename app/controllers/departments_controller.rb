class DepartmentsController < ApplicationController

  # This renders the top page and will show the newest
  # games, DVDs, music etc eventually.

  def index

    # We'll go through the Department model instead of this hack job
    # when we have more departments

    platforms = ['Nintendo 3DS', 'PlayStation 4', 'Xbox One', 'PlayStation Vita']

    # This will run a separate query for each platform
    # and put the results in an array to be used in the view
    # Learning the methods in the enumerable module should beef up your Ruby
    # http://ruby-doc.org/core-2.1.2/Enumerable.html

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

  # This could maybe show all items in a given department to begin with

  def show

  end

end
