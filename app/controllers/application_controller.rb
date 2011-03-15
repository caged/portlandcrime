class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_last_import
  before_filter :set_time_range
  
  private
  
  def set_last_import
    @last_import ||= ImportStatistic.sort(:created_at).last
  end  
  
  def set_time_range
    @from = Time.now - 1.year
    @to = Time.now
  end
end
