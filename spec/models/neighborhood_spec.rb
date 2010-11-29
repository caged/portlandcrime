require 'spec_helper'

describe Neighborhood do
  before do
    @neighborhood = Factory.create(:neighborhood, :name => 'Pearl')
  end
  
  it "should generate permalink from name" do
    @neighborhood.permalink.should == @neighborhood.name.parameterize
  end
  
  it "should have some crimes" do
    @neighborhood.crimes.first.neighborhood_id.should == @neighborhood.id
  end
  
  it "should have demographics" do
    @neighborhood.demographics.should == []
  end
  
  it "should only fetch portland neighborhoods" do
    Factory.create(:neighborhood, :portland => false)
    Factory.create(:neighborhood, :portland => false)
    Factory.create(:neighborhood)
    Factory.create(:neighborhood)
    Factory.create(:neighborhood)
    
    nhoods = Neighborhood.portland_only.all
    nhoods.count.should == 4
    nhoods.each do |nh|
      nh.portland.should == true
    end
  end
  
  it 'should generate properly formatted geojson' do
    @neighborhood.as_geojson.keys.each do |k|
      [:id, :geometry, :properties].include?(k).should == true
    end
  end
end