class SearchController < ApplicationController
  def search
    @items = params[:q].nil? ?
       [] : Item.search("#{params[:q].delete('~')}~").records
  end
end
