require 'spec_helper'

describe Crime do
  before do
    @offense = Factory.create(:offense)
    @neighborhood = Factory.create(:neighborhood)
    
    @crime = Factory.create(:crime)
    @crime2 = Factory.create(:crime, :loc => nil)
    
    @crime.offense = @offense
    @crime.neighborhood = @neighborhood
    @crime.save
  end
  
  it "should have a geolocation or zero" do
    @crime2.loc.should == {'lat' => 0, 'lon' => 0}
  end
  
  it "should belong to an offense" do
    @crime.offense.should == @offense
  end
  
  it "should belong to a neighborhood" do
    @crime.neighborhood.should == @neighborhood
  end
end