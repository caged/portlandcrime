class NeighborhoodsController < ApplicationController
  caches_page :show, :index
  
  def index
    @this_year_start = Time.now.beginning_of_year
    @neighborhoods = Neighborhood.all
    
    respond_to do |wants|
      wants.html do
        totals = {}
        this_year_trends = MongoMapper.database["neighborhood_totals_for_#{@this_year_start.year}"] 
        this_year_trends.find.each do |tr|
          sum = 0
          tr['value'].each {|k, v| sum += v}
          totals[tr['_id']] = sum.to_i
        end
        
        @totals = totals
      end
      wants.json do
        ids = params[:ids][0].split(',')
        @neighborhoods = @neighborhoods.select { |n| ids.include?(n.id.to_s) }
        render :json => @neighborhoods
      end
      wants.geojson do
        render :geojson => @neighborhoods
      end
    end
  end
  
  def show
    @this_year_start = Time.now.beginning_of_year
    @last_year_start = @this_year_start - 1.year
    
    @offenses = Offense.sort([['type.order', 1], ['order', 1]]).all.group_by(&:type)    
    @neighborhood = Neighborhood.first(:permalink => params[:id])

    respond_to do |wants|
      wants.html do
        @crimes = @neighborhood.crimes.limit(5).sort(:reported_at => -1)
        
        # Based on yearly trends, there is a window of a couple weeks for
        # crimes to be fully reported.
        @this_years_total = @neighborhood.crimes.between(@this_year_start, (Time.now - 1.week)).count
        @last_years_total = @neighborhood.crimes.between(@last_year_start, (Time.now - 1.week) - 1.year).count

        @this_year_trends = MongoMapper.database["neighborhood_totals_for_#{@this_year_start.year}"].find_one(:_id => @neighborhood.id)          
        @last_year_trends = MongoMapper.database["neighborhood_totals_for_#{@last_year_start.year}"].find_one(:_id => @neighborhood.id)
      end
      wants.geojson do
        geo = @neighborhood
        render :geojson => [geo]
      end
    end
  end
end
