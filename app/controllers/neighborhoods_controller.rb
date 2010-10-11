class NeighborhoodsController < ApplicationController
  def index
    respond_to do |wants|
      wants.json do
        @neighborhoods = Neighborhood.find(params[:ids][0].split(','))
        render :json => @neighborhoods
      end
    end
  end
end
