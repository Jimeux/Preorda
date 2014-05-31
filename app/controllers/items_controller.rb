class ItemsController < ApplicationController
  def index
    @items = [Item.n3ds, Item.ps4, Item.xbox1]
  end
end