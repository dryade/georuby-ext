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

  describe "#wgs84_to_google" do
    
    it "should return google coordinates" do
      subject.lat, subject.lng = 45, 90
      #subject.wgs84_to_google.eql?(Geokit::LatLng.new(5621521.48619207, 10018754.1713946)).should be_true 
    end
    
  end

  describe "#google_to_wgs84" do
    
    it "should wgs84 coordinates" do
      subject.lat, subject.lng = 45, 90
      #subject.google_to_wgs84.eql?(Geokit::LatLng.new(0.000404241877844722, 0.000808483755707569)).should be_true 
    end
    
  end

end
