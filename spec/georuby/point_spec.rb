require 'spec_helper'

describe GeoRuby::SimpleFeatures::Point do

  describe "to_rgeo" do
    it "should create a RGeo::Feature::Point" do
      point(0,0).to_rgeo.should == rgeo_point(0,0)
    end 
  end

  describe "centroid" do

    def centroid(*args)
      GeoRuby::SimpleFeatures::Point.centroid *args
    end
    
    it "should return nil if no points in input" do
      centroid([]).should be_nil
    end
    
    it "should return point in input if only one" do
      centroid([point(0,0)]).should == point(0,0)
    end

    it "should return middle if two points in input" do
      centroid([point(0.0,0.0), point(1.0,0.0)]).should == point(0.5,0.0)
    end
    
    it "should return centroid of given points" do
      centroid([point(0,0), point(0,2), point(2,2), point(2,0)]).should == point(1,1)
    end
    
  end

  describe "#to_wgs84" do
    it "should return true when we compare points coordinates" do
      point(1, 1).to_wgs84.should == point(0.000008983152841195214, 0.000008983152840993819, 4326)
    end

    it "should return a point with 4326 srid" do
      point.to_wgs84.srid.should == 4326
    end
  end
end
