class ItemsController < ApplicationController

  def show
    @item = Item.includes(:products)
                .friendly
                .find(params[:id])

    @alternatives = Item.where(title: @item.title,
                               department_id: @item.department_id,
                               variation: @item.variation)
                        .where.not(id: @item.id)

    @variations = Item.where('lower(title) = ?', @item.title.downcase)
                      .where(platform_id: @item.platform_id,
                             department_id: @item.department_id,)
                      .where.not(id: @item.id)
  end

end