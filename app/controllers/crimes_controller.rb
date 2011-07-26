class CrimesController < ApplicationController  
  caches_page :index, :show
  
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
    @crime = Crime.find(params[:id])
    @similar = Crime.between(@crime.reported_at - 1.hours, @crime.reported_at + 1.hours).where(:code => @crime.code, :case_id.ne => @crime.case_id).limit(10).all
  end
end
