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

  describe ".srid!" do
    
    it "should return the uniq srid of given geometries" do
      GeoRuby::SimpleFeatures::Geometry.srid!([point.to_google]).should == 900913
    end

    it "should raise an error when srid is not uniq" do
      lambda do
        GeoRuby::SimpleFeatures::Geometry.srid!([point, point.to_google])
      end.should raise_error
    end

  end

  describe "#to_wgs84" do

    let(:projected_geometry) { mock }

    it "should return a geometry with 4326 srid" do
      subject.to_wgs84.srid.should == 4326
    end

    it "should project the geometry in wgs84" do
      subject.should_receive(:project_to).with(4326).and_return(projected_geometry)
      subject.to_wgs84.should == projected_geometry
    end

  end

  describe "#to_google" do

    let(:projected_geometry) { mock }

    it "should return a geometry with 900913 srid" do
      subject.to_google.srid.should == 900913
    end

    it "should project the geometry in google" do
      subject.should_receive(:project_to).with(900913).and_return(projected_geometry)
      subject.to_google.should == projected_geometry
    end

  end

end
