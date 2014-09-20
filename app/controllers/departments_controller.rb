class DepartmentsController < ApplicationController

  def index
    @departments = Department.includes(:platforms).order('name ASC')
  end

  def show
    @department = Department.includes(:platforms).find(params[:id])

    @items = @department.preview_items.paginate(
        page: params[:page], per_page: 12)
    @items = @items.where(platform: params[:platform]) if params[:platform]
  end

end
