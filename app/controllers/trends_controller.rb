class TrendsController < ApplicationController
  caches_page :index
  
  def index
    years = %w(2009 2010)
    
    respond_to do |wants|
      wants.html do
        summary_col = MongoMapper.database["summaries_for_offenses_in_#{years.last}"]
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
        weeks = []
        trends = []
        
        years.each do |year|
          col = MongoMapper.database["weekly_citywide_totals_report_#{year}"]
          results = col.find.to_a
          trends << results
        end
        
        (0..52).each do |i|
          prev = trends.first[i] ? trends.first[i]['value']['count'] : 0
          curr = trends.last[i] ? trends.last[i]['value']['count'] : 0
          
          week = {:week => (i + 1), :prev => prev, :curr => curr}
          weeks << week
        end 
        
        render :json => weeks
      end
    end
  end
end
