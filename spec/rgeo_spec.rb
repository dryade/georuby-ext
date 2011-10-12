require "spec_helper"

describe RGeo::Geos::PointImpl do

  subject { rgeo_point }

  describe "#to_georuby" do

    it "should return a GeoRuby::SimpleFeatures::Point" do
      subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::Point)
    end

    it "should have the same x, y and srid" do
      subject.to_georuby.should have_same(:x, :y, :srid).than(subject)
    end

  end

end

describe RGeo::Geos::LineImpl do

  subject { rgeometry("LINESTRING(0 0, 1 1)") }

  describe "#to_georuby" do
    
    it "should return a GeoRuby::SimpleFeatures::LineString" do
      subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::LineString)
    end

    it "should return a LineString with the same information" do
      subject.to_georuby.should == geometry("LINESTRING(0 0, 1 1)")
    end

  end

end

describe RGeo::Geos::PolygonImpl do

  subject { rgeometry("POLYGON((0 0,1 0,0 1,0 0))") }

  describe "#to_georuby" do
    
    it "should return a GeoRuby::SimpleFeatures::Polygon" do
      subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::Polygon)
    end

    it "should return a Polygon with the same information" do
      subject.to_georuby.should == geometry("POLYGON((0 0,1 0,0 1,0 0))")
    end

  end

end

describe RGeo::Geos::MultiPolygonImpl do

  subject { rgeometry("MULTIPOLYGON (((30 20, 10 40, 45 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))") }

  describe "#to_georuby" do
    
    it "should return a GeoRuby::SimpleFeatures::MultiPolygon" do
      subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::MultiPolygon)
    end

    it "should return a MultiPolygon with the same information" do
      subject.to_georuby.should == geometry("MULTIPOLYGON (((30 20, 10 40, 45 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))")
    end

  end

end
