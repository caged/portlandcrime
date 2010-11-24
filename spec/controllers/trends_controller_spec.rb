require 'spec_helper'

describe TrendsController do
  render_views
  
  it "should render trends" do
    get :index
    response.should be_success
  end
end
