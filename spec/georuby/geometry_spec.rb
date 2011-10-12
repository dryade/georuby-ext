require "spec_helper"

describe GeoRuby::SimpleFeatures::Geometry do

  subject { point }

  describe "#to_ewkt" do

    it "should return as_ewkt result" do
      subject.to_ewkt.should == subject.as_ewkt
    end
    
  end

  it "should be wgs84 when srid == 4326" do
    subject.srid = 4326
    subject.should be_wgs84
  end

  it "should not be wgs84 when srid isn't 4326" do
    subject.srid = 900913
    subject.should_not be_wgs84
  end

  describe "#inspect" do

    it "should include geometry class name" do
      subject.inspect.should include(subject.class.name)
    end
    
    it "should include geometry ekwt" do
      subject.inspect.should include(subject.to_ewkt)
    end

  end

end
