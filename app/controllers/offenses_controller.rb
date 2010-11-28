class OffensesController < ApplicationController
  caches_page :show
  def index
  
  end
  
  def show    
    @offense = Offense.first(:permalink => params[:id])
    respond_to do |format|
      format.html
      format.geojson do 
        @crimes = @offense.crimes.in_the_past(30.days).all
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
    end
  end
end
