class DepartmentsController < ApplicationController

  def index
    # @departments is currently set in ApplicationController
    # Leave this blank to avoid hitting the DB again.

    respond_to do |format|
      format.html
      format.json { render json: { content: get_items_page } }
    end
  end

  def show
    @department = Department.includes(:platforms).friendly.find(params[:id])
    @platform   = @department.platforms.friendly.find(params[:platform]) if params[:platform]

    # Create an instance var to allow pagination of the items association
    @items = @department.preview_items.paginate(
        page: params[:page], per_page: 24)
    @items = @items.where(platform: @platform) if @platform
  end

  private

  def get_items_page
    page  = params[:page] || 1
    items = Item.latest_page(params[:id], page)
    render_to_string(template: 'departments/_items',
                     formats: ['html'],
                     layout: false,
                     locals: { items: items })
  end

end
