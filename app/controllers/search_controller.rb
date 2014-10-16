class SearchController < ApplicationController
  def search
    #@items = params[:q].nil? ?
    #   [] : Item.search("*#{params[:q].gsub(/[~*]/,'')}*").records
    if params[:q].blank?
      #TODO: Do validations checking
    end

    query_param = "%#{params[:q]}%"
    @items = Item.where('title ILIKE ? OR creator ILIKE ?',
                        query_param,
                        query_param)
  end
end
