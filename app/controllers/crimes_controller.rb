class CrimesController < ApplicationController  
  caches_page :index
  
  def index
    if params[:neighborhood_id]
      @neighborhood = Neighborhood.first(:permalink => params[:neighborhood_id])
    end
    
    respond_to do |wants|
      wants.html do
        @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type)
      end
      wants.geojson do
        if !@neighborhood.nil?
          @crimes = @neighborhood.crimes.in_the_past(7.days).all
        else
          @crimes = Crime.in_the_past(7.days).all
        end
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
      wants.rss do 
        if !@neighborhood.nil?
          @crimes = @neighborhood.crimes.sort(:reported_at.desc).limit(20)
        end
        render :layout => false
      end
    end
  end
  
  def show
    @crime = Crime.first(params[:id])
  end
end
