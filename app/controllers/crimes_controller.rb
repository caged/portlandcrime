class CrimesController < ApplicationController  
  def index
    respond_to do |format|
      format.html { @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type) }
      format.json do
        @crimes = Crime.where(
          :reported_at.gte => Time.now - 7.days, 
          :reported_at.lt => Time.now)
        render :geojson => @crimes
      end
    end
  end
end
