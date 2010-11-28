require 'spec_helper'

describe SiteController do
  it "should render about" do
    get :about
    response.should be_success
  end
end
