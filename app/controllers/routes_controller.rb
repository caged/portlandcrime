class RoutesController < ApplicationController
  caches_page :index
  def index
    respond_to do |wants|
      wants.geojson do
        case params[:type].to_sym
          when :max       then routes = TrimetRoute.max.all
          when :streetcar then routes = TrimetRoute.streetcar.all
          when :rail      then routes = TrimetRoute.rail.all
        end
        
        render :geojson => routes
      end
    end
  end
end
