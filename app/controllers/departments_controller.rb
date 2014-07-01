class DepartmentsController < ApplicationController

  # This renders the top page and will show the newest
  # games, DVDs, music etc eventually.

  def index
    @departments = Department.latest_items
  end

  # This could maybe show all items in a given department to begin with

  def show

  end

end
