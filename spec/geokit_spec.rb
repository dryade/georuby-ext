require "spec_helper"

describe GeoKit::LatLng do
  
  subject { GeoKit::LatLng.new }

  describe "#valid?" do
    
    it "should be invalid when lat is nil" do
      subject.lat, subject.lng = nil, 45
      subject.should_not be_valid
    end

    it "should be invalid when lng is nil" do
      subject.lat, subject.lng = 45, nil
      subject.should_not be_valid
    end

    it "should be valid when lat is between -90 and 90, lng between -180 and 180" do
      subject.lat, subject.lng = 45, 90
      subject.should be_valid
    end

  end

end
