require 'spec_helper'

describe NeighborhoodsController do  
  render_views
  
  before do
    @neighborhood_factories = [Factory(:neighborhood), Factory(:neighborhood), Factory(:neighborhood)]
  end
  
  context "index" do    
    it "should render index successfully" do
      get :index
      # assigns[:this_year_start].should == Time.now.beginning_of_year
      # assigns[:neighborhoods].should == @neighborhood_factories
      # assigns[:totals].should == {}
      # 
      # response.code.should == '200'
      response.should be_success
    end
    
    it "should find select neighborhoods and render json when given a comma seperated string of ids" do
      get :index, :ids => [@neighborhood_factories.collect { |n| n.id.to_s }[0,1].join(',')], :format => :json
      
      assigns[:neighborhoods].should == @neighborhood_factories[0,1]
      response.should be_success
    end
    
    it "should respond to geojson" do
      get :index, :format => :geojson
      
      assigns[:neighborhoods].should == @neighborhood_factories
      response.should be_success
    end
  end
  
  context 'show' do
    it "should respond to geojson given a neighborhood id" do
      get :show, :id => @neighborhood_factories[0].permalink
      
      assigns[:this_year_start].should == Time.now.beginning_of_year
      assigns[:last_year_start].should == assigns[:this_year_start] - 1.year
      assigns[:offenses].should == {}
      assigns[:neighborhood].should == @neighborhood_factories[0]
      assigns[:crimes].should_not be_nil
      assigns[:this_years_total].should_not be_nil
      assigns[:last_years_total].should_not be_nil
      
      # How should tables created by map reduce jobs be tested?
      # assigns[:this_year_trends].should == {}
      # assigns[:last_year_trends].should == {}
      
      response.should be_success
    end
    
    it "should render the neighborhood as geojson" do
      get :show, :id => @neighborhood_factories[0].permalink, :format => :geojson
      response.should be_success
    end
  end
end
