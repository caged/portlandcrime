require 'spec_helper'

describe Crime do
  before do
    @offense = Factory.create(:offense)
    @neighborhood = Factory.create(:neighborhood)
    
    @crime = Factory.create(:crime, :reported_at => Time.zone.parse('25/09/2010'))
    @crime2 = Factory.create(:crime, :reported_at => Time.zone.parse('01/01/2010'), :loc => nil)
    @crime3 = Factory.create(:crime, :reported_at => Time.zone.parse('01/01/2010 3:00PM'), :loc => nil)
    
    
    Factory.create(:crime, :reported_at => Time.zone.parse('01/05/2009'))
    Factory.create(:crime, :reported_at => Time.zone.parse('01/06/2009'))
    
    Factory.create(:crime, :reported_at => Time.zone.now)
    Factory.create(:crime, :reported_at => Time.zone.now)
    
        
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
  
  it 'should find crime within a given year' do
    old_crime = Crime.in_the_year(2009)
    old_crime.count.should == 2
  end
  
  it "should find crime between two dates" do
    crime = Crime.between(Time.zone.parse('01/05/2009'), Time.zone.parse('01/07/2009'))
    crime.count.should == 2
  end
  
  it "should find crime in the past" do
    crime = Crime.in_the_past(1.days)
    crime.count.should == 2
  end
  
  it "should know if a crime happened at dark" do
    @crime.at_dark?.should == true
  end
  
  it "should know if a crime happened during the day" do
    @crime3.at_daylight?.should == true
  end
end