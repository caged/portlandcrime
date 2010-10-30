class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_last_import
  
  private
  
  def set_last_import
    @last_import ||= ImportStatistic.sort(:created_at).last
  end
end
