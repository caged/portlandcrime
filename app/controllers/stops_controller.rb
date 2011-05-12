class StopsController < ApplicationController
  caches_page :index
  def index
    respond_to do |wants|
      wants.geojson do
        case params[:type].to_sym
          when :max       then stops = TransitStop.max_stops.all
          when :streetcar then stops = TransitStop.streetcar_stops.all
          when :rail      then stops = TransitStop.rail_stops.all  
          else                 stops = TransitStop.bus_stops.all
        end
        
        render :geojson => stops
      end
    end
  end
  
  def show
    @stop = TransitStop.find(params[:id])
  end
end
