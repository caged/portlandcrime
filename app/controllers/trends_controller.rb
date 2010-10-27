class TrendsController < ApplicationController
  caches_page :index
  
  def index
    time = Time.zone.now
    
    respond_to do |wants|
      wants.html do
        summary_col = MongoMapper.database["summaries_for_offenses_in_#{time.year}"]
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
        col = MongoMapper.database["weekly_citywide_totals_report_#{time.year}"]
        if col.nil?
          render :json => {:error => "Reports haven't been generated for #{time.year}"}
        else
          render :json => col.find.to_a
        end
      end
    end
  end
end
