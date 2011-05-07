class TrendsController < ApplicationController
  caches_page :index  
  def index    
    respond_to do |wants|
      wants.html do
        summary_col = MongoMapper.database["summaries_for_offenses_in_#{@to.year}"]
        summaries = summary_col.nil? ? [] : summary_col.find.to_a
        
        # Looks like I'm going to need to denormalize a little and include the 
        # offense name in the crime object so I won't have to make queries such as this
        # It feels hacky
        @offenses = Offense.sort(:name).find(summaries.map { |o| o['_id'] })
        @offenses.map! do |o|
          summary = summaries.detect {|s| o.id == s['_id']}
          {:offense => o, :summary => summary}
        end
      end

      wants.json do
        trends = []
        weeks  = []
        months = []
        years = [@from.year, @to.year]
        
        years.each do |year|
          trends << MongoMapper.database["weekly_citywide_totals_report_#{year}"].find.to_a         
        end
        
        wprev = {:series => 'prev', :values => []}
        wcurr = {:series => 'curr', :values => []}
        (0..52).each do |i|
          prev = trends.first[i] ? trends.first[i]['value']['count'] : 0
          curr = trends.last[i] ? trends.last[i]['value']['count'] : 0
          wprev[:values] << {:week => (i + 1), :value => prev}
          wcurr[:values] << {:week => (i + 1), :value => curr}
        end 
        
        trends = []
        years.each do |year|
          col = MongoMapper.database["monthly_citywide_totals_report_#{year}"]          
          trends << col.find.to_a
        end
        
        mprev = {:series => 'prev', :values => []}
        mcurr = {:series => 'curr', :values => []}
        (0..11).each do |i|
          prev = trends.first[i] ? trends.first[i]['value']['count'] : 0
          curr = trends.last[i] ? trends.last[i]['value']['count'] : 0
          
          mprev[:values] << {:month => i, :value => prev}
          mcurr[:values] << {:month => i, :value => curr}          
        end
                
        render :json => [[wprev, wcurr], [mprev, mcurr]]
      end
    end
  end

  def transit
    @sc_routes = TransitRoute.streetcar_routes.all
    @max_routes = TransitRoute.max_routes.all
    @bus_routes = TransitRoute.bus_routes.all
  end
end
