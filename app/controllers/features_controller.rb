class FeaturesController < ApplicationController

  def create
    Feature.create! feature_params
    redirect_to :back
  end

  private

  def feature_params
    params.require(:feature).permit(:image, :item_id)
  end

end
