class OffensesController < ApplicationController
  caches_page :show, :recurring_neighborhoods
  
  def index
    respond_to do |wants|
      wants.json do
        render :json => Offense.all
      end
    end
  end
  
  def show    
    @offense = Offense.first(:permalink => params[:id])
    
    summary_col = MongoMapper.database["summaries_for_offenses_in_#{@to.year}"]
    @trend = summary_col.find_one(:_id => @offense.id)
    
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
  
  def history
    offense = Offense.first(:permalink => params[:offense_id])
    history_col = MongoMapper.database["#{@from.year}_#{@to.year}_monthly_offense_history"]
    history = history_col.find('_id.offense' => offense.id).sort([['_id.year', 1], ['_id.month', 1]]).to_a
    history.collect! do |h|
      {:date => Time.new(h['_id']['year'], h['_id']['month'] + 1), :count => h['value']}
    end
    render :json => history
  end
  
  def recurring_neighborhoods
    respond_to do |format|
      format.json do
        ids = params[:ids][0].split(',')
        neighborhoods = Neighborhood.all(:id.in => ids)
        render :json => neighborhoods
      end
    end
  end
end
