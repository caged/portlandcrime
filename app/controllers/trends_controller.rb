class TrendsController < ApplicationController
  def index
    time = Time.zone.now
    col = MongoMapper.database["weekly_citywide_totals_report_#{time.year}"]
    
    respond_to do |wants|
      wants.html { }
      wants.json do
        if col.nil?
          render :json => {:error => "Reports haven't been generated for #{time.year}"}
        else
          weeks = col.find.map do |obj|
            bow = Time.zone.parse(obj['value']['date'].to_s).beginning_of_week.strftime('%B %d %Y')
            eow = Time.zone.parse(obj['value']['date'].to_s).end_of_week.strftime('%B %d %Y')
            obj['_id'] = "#{bow} - #{eow}"
            obj
          end
          
          render :json => weeks
        end
      end
    end
  end
end
