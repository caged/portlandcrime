class NeighborhoodsController < ApplicationController
  def index
    respond_to do |wants|
      wants.json do
        @neighborhoods = Neighborhood.find(params[:ids][0].split(','))
        render :json => @neighborhoods
      end
    end
  end
  
  # TODO: Based on yearly trends, there is a window of a couple weeks for
  # crimes to be fully reported.  Think about accounting for this to product more
  # accurate numbers.
  def show
    @this_year_start = Time.now.beginning_of_year
    @last_year_start = @this_year_start - 1.year
    
    @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type)    
    @neighborhood = Neighborhood.first(:permalink => params[:id])

    respond_to do |wants|
      wants.html do
        @this_years_total = @neighborhood.crimes.between(@this_year_start, (Time.now - 1.week)).count
        @last_years_total = @neighborhood.crimes.between(@last_year_start, (Time.now - 1.week) - 1.year).count

        @this_year_trends = MongoMapper.database["neighborhood_totals_for_#{@this_year_start.year}"].find_one(:_id => @neighborhood.id)          
        @last_year_trends = MongoMapper.database["neighborhood_totals_for_#{@last_year_start.year}"].find_one(:_id => @neighborhood.id)
      end
      wants.json do
        geo = @neighborhood.as_geojson
        render :geojson => [geo]
      end
    end
  end
end
