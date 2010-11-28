class CrimesController < ApplicationController  
  caches_page :index
  
  def index
    respond_to do |wants|
      wants.html do
        @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type)
      end
      wants.geojson do
        @crimes = Crime.in_the_past(7.days).all
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
    end
  end
  
  def show
    respond_to do |wants|
      crimes = []
      wants.geojson do
        if params[:neighborhood_id]
          neighborhood = Neighborhood.where(:permalink => params[:neighborhood_id]).first
          unless neighborhood.nil?
            crimes = neighborhood.crimes.in_the_past(7.days).all
          end
        end
      end
      render :geojson => crimes
    end
  end
end
