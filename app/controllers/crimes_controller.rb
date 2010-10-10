class CrimesController < ApplicationController  
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
end
