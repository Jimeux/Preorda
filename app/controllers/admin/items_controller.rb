class Admin::ItemsController < ApplicationController

  before_action do
    redirect_to root_path unless current_user && current_user.admin?
  end

  def index
    @departments = Department.all
  end

  def show
    @department = Department.friendly.find(params[:id])
    @items = @department.preview_items.paginate(
        page: params[:page], per_page: 18)
  end

  def edit
    @item = Item.friendly.find(params[:id])
    #render 'admin/items/edit'
  end

  def update
    @item = Item.friendly.find(params[:id])
    @item.update_attributes(item_params)
    render :edit
  end

  def destroy
    @item = Item.friendly.find(params[:id])
    @item.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  def merge
    item  = Item.find(params[:item_id])
    merge = Item.includes(:products).find(params[:merge_id])
    merge.products.each { |p| p.item_id = item.id ; p.save! }
    merge.reload

    if merge.description && !item.description
      item.description = merge.description
      item.save!
    end
    if merge.variation && !item.variation
      item.variation = merge.variation
      item.save!
    end
    merge.destroy

    redirect_to :back
  end

  private

  def item_params
    params.require(:item).permit(
        :title, :variation, :creator, :image, :platform_id, :release_date, :description)
  end

end