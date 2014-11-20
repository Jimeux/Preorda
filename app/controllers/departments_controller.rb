class DepartmentsController < ApplicationController

  def index
    # @departments is currently set in ApplicationController
    # Leave this blank to avoid hitting the DB again.

    respond_to do |format|
      format.html
      format.json { render json: index_json }
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

  def index_json
    page = params[:page] || 1

    Department.find(params[:id]).items.paginate(page: page, per_page: 6).each_with_object([]) do |item, item_array|
      item_array << {
          url:           item_path(item),
          variation:     item.variation,
          image_url:     item.image.url(:thumb),
          image_height:  view_context.thumb_height_for(item.department),
          title:         item.title.size > 16 ? item.title.first(13) + '…' : item.title,
          creator:       view_context.is_in_music_dept?(item) ? view_context.print_summary_creator(item) : '',
          platform:      item.platform ? item.platform.name : '',
          release_date:  view_context.print_time_to_release(item),
          price:         item.lowest_price > 0 ? view_context.raw(view_context.number_to_currency(item.lowest_price)) : '-'
      }
    end.to_json
  end
=begin

  {
      id: dept.id,
      name: dept.name,
      heading: t('dept.index.coming_soon', dept: t("dept.#{dept.name}")),
      view_link: short_dept_path(dept),
      view_all: t('dept.index.view_all'),
      items: dept_items
  }.to_json
=end


end
