class ItemsController < ApplicationController

  def show
    @item = Item.includes(:products)
                .friendly
                .find(params[:id])
  end

end