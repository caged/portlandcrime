class OffensesController < ApplicationController
  def index
  end
  
  
  def show    
    @offense = Offense.first(:permalink => params[:id])
    respond_to do |format|
      format.html
      format.json do 
        @crimes = @offense.crimes.in_the_past(30.days)
        logger.info "Found #{@crimes.count} crimes"
        render :geojson => @crimes
      end
    end
  end
end
