class RoutesController < ApplicationController
  caches_page :index, :type
  
  def index
    @sc_routes = TransitRoute.streetcar_routes.all
    @max_routes = TransitRoute.max_routes.all
    @bus_routes = TransitRoute.bus_routes.all
  end
  
  def type
    respond_to do |wants|
      wants.html {}
      wants.geojson do
        case params[:type].to_sym
          when :max       then routes = TransitRoute.max_routes.all
          when :streetcar then routes = TransitRoute.streetcar_routes.all
          when :rail      then routes = TransitRoute.rail_routes.all
        end
        
        render :geojson => routes
      end
    end
  end
  
  def show
    @route  = TransitRoute.find(params[:id])
    @route2 = TransitRoute.first(:rte => @route.rte, :id.ne => @route.id)
    @routes = [@route, @route2].sort_by(&:dir)
    @stops = @route.stops
  end
end