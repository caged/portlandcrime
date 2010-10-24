require 'spec_helper'

describe CrimesController do
  render_views
  
  it "should find crimes" do
    get :index
    response.should be_success
  end
end
