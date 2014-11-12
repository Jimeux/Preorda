class FeaturesController < ApplicationController

  def index
    @features = Feature.includes(:item)
    respond_to do |format|
      format.json { render json: featured_json }
    end
  end

  def create
    Feature.create! feature_params
    redirect_to :back
  end

  private

  def featured_json
    @features.each_with_object([]) do |feature, array|
      array << {
          link_href: item_path(feature.item),
          image_url: feature.image
      }
    end.to_json
  end

  def feature_params
    params.require(:feature).permit(:image, :item_id)
  end

end
