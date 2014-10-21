class SearchController < ApplicationController
  def search
    query_param = params[:q]

    if query_param.blank? || query_param.size < 3
      @items = Item.none  # Creates a blank ActiveRecord::Relation
    else
      query_param = "%#{params[:q]}%"
      @items = Item.includes(:department)
                   .includes(:platform)
                   .includes(:products)
                   .where('title ILIKE ? OR creator ILIKE ?', query_param, query_param)
    end

    @items = @items.paginate(page: params[:page], per_page: 24)
                            # TODO: Set per_page as a var somewhere that users can change
  end
end