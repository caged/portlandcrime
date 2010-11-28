require 'spec_helper'

describe OffensesController do
  render_views
  
  before do
    @offense = Factory.create(:offense)
  end
  
  context 'index' do
    it "should render json" do
      get :index, :format => :json
      response.should be_success
    end
  end
  
  context 'show' do
    it "should show offense" do    
      get :show, :id => @offense.permalink
      assigns[:offense].should == @offense
      response.should be_success
    end
    
    it "should respond to json" do    
      get :show, :id => @offense.id.to_s, :format => :json
      assigns[:offense].should == @offense
      response.should be_success
    end
    
    it "should respond to geojson and assign crimes" do  
      get :show, :id => @offense.permalink, :format => :geojson
      assigns[:offense].should == @offense
      assigns[:crimes].should == []
      
      response.should be_success
    end
  end
end
