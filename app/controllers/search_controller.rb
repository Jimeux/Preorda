class SearchController < ApplicationController
  def search
    @items = params[:q].nil? ?
       [] : Item.search("*#{params[:q].gsub(/[~*]/,'')}*").records
  end
end
