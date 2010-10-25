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
          render :json => col.find.to_a
        end
      end
    end
  end
end
