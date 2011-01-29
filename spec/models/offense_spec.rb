require 'spec_helper'

describe Offense do
  before do
    @offense = Factory.create(:offense_with_crimes, :name => 'Burglary')
  end
  
  it "should generate permalink and code from name" do
    @offense.name.should == 'Burglary'
    @offense.code.should == 'bu'
    @offense.permalink.should == 'burglary'
  end
  
  it "should have a type name and order" do
    @offense.type['name'].should == 'Non-Violent'
    @offense.type['order'].should == 1
  end
  
  it 'should have some crimes' do
    @offense.crimes.first.offense_id.should == @offense.id
  end
end