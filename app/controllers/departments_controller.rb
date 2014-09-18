class DepartmentsController < ApplicationController

  def index
    @departments = Department.joins(:items).group("departments.id").having("count(items.id) > ?",0)
    .order('name ASC')
  end

  def show
    @department = Department.find(params[:id])
    @items = @department.preview_items.paginate(
        page: params[:page], per_page: 12)
  end

end
