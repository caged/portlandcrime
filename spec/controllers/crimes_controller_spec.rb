require 'spec_helper'

describe CrimesController do  
  render_views
  
  context "index" do    
    it "should render index successfully" do
      get :index
      assigns[:offenses].should == {}
      
      response.code.should == '200'
      response.should be_success
    end
    
    it "should respond to geojson" do
      get :index, :format => :geojson
      
      assigns[:crimes].should == []
      
      response.code.should == '200'
      response.should be_success      
    end
  end
  
  context 'show' do
    it "should respond to geojson given a neighborhood id" do
      get :show, :neighborhood_id => 'portland-0', :format => :geojson
      response.should be_success
    end
  end
end
