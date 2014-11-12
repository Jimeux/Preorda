class FeaturesController < ApplicationController

  def index
    @features = Feature.all
    respond_to do |format|
      format.json { render json: @features }
    end
  end

  def create
    Feature.create! feature_params
    redirect_to :back
  end

  private

  def feature_params
    params.require(:feature).permit(:image, :item_id)
  end

end
