class OffensesController < ApplicationController
  caches_page :show
  def index
    respond_to do |wants|
      wants.json do
        render :json => Offense.all
      end
    end
  end
  
  def show    
    @offense = Offense.first(:permalink => params[:id])
    respond_to do |format|
      format.html
      format.json do
        @offense = Offense.find(params[:id])
        render :json => @offense
      end
      format.geojson do 
        @crimes = @offense.crimes.in_the_past(30.days).all
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
    end
  end
end
