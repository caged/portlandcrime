require 'spec_helper'

describe OffensesController do
  render_views
  
  it "should show offense" do
    get :show, :id => 'homicide'
    response.should be_success
  end
end
