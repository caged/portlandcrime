class RoutesController < ApplicationController
  caches_page :index
  def index
    respond_to do |wants|
      wants.geojson do
        case params[:type].to_sym
          when :max then routes = TrimetRoute.max_routes.all
          when :streetcar then routes = TrimetRoute.streetcar_routes.all
          else routes = TrimetRoute.bus_routes.all
        end
        
        render :geojson => routes
      end
    end
  end
end
