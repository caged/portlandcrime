class CrimesController < ApplicationController  
  caches_page :index
  
  def index
    respond_to do |format|
      format.html do
        @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type)
      end
      format.json do
        @crimes = Crime.in_the_past(7.days)
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
    end
  end
  
  def show
    if params[:neighborhood_id]
      neighborhood = Neighborhood.where(:permalink => params[:neighborhood_id]).first
      unless neighborhood.nil?
        crimes = neighborhood.crimes.in_the_past(30.days).all
        render :geojson => crimes
      end
    end
  end
end
