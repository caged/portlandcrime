class StopsController < ApplicationController
  caches_page :index
  def index
    respond_to do |wants|
      wants.geojson do
        case params[:type].to_sym
          when :max       then stops = TrimetStop.max_stops.all
          when :streetcar then stops = TrimetStop.streetcar_stops.all
          when :rail      then stops = TrimetStop.rail_stops.all  
          else                 stops = TrimetStop.bus_stops.all
        end
        
        render :geojson => stops
      end
    end
  end
end
