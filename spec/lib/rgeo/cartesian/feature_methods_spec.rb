require "spec_helper"

module RGeo
  module Cartesian

    describe PointImpl do
      
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
    
    describe LineStringImpl do
      
      subject { rgeometry("LINESTRING(0 0, 1 1, 2 2)") }
      
      describe "#to_linear_ring" do
        
        it "should return a GeoRuby::SimpleFeatures::LinearRing" do                          
          subject.to_linear_ring.should == rgeometry("LINESTRING(0 0, 1 1, 2 2, 0 0)")
        end
        
      end
      
      describe "#to_georuby" do
        
        it "should return a GeoRuby::SimpleFeatures::LineString" do
          subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::LineString)
        end
        
        it "should return a LineString with the same information" do
          subject.to_georuby.should == geometry("LINESTRING(0 0, 1 1, 2 2)")
        end
        
      end
      
    end
    
    # describe RGeo::Geos::LinearRingImpl do

    #   subject { rgeometry("LINEARRING(0 0, 1 1, 0 0)") }
    
    #   describe "#to_georuby" do
    
    #     it "should return a GeoRuby::SimpleFeatures::LineString" do
    #       subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::LinearRing)
    #     end
    
    #     it "should return a LineString with the same information" do
    #       subject.to_georuby.should == geometry("LINEARRING(0 0, 1 1, 1 1)")
    #     end
    
    #   end
    
    # end
    
    describe PolygonImpl do
      
      subject { rgeometry("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))") }
      
      describe "#to_georuby" do
        
        it "should return a GeoRuby::SimpleFeatures::Polygon" do
          subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::Polygon)
        end
        
        it "should return a georuby polygon with the same information" do
          subject.to_georuby.should == geometry("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))")
        end
        
        it "should return a georuby polygon with the same information" do
          rgeo_polygon = rgeometry("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0), (0.25 0.25,0 0.75,0.75 0.75,0.75 0.25))")
          rgeo_polygon.to_georuby.should == geometry("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0), (0.25 0.25,0 0.75,0.75 0.75,0.75 0.25))")
        end
        
      end
      
    end

    describe MultiPolygonImpl do
      
      subject { rgeometry("MULTIPOLYGON ( ((0 0, 0 1, 1 1, 1 0, 0 0), (0.25 0.25,0 0.75,0.75 0.75,0.75 0.25, 0.25 0.25)), ((15 5, 40 10, 10 20, 5 10, 15 5)) )") }
      
      describe "#to_georuby" do
        
        it "should return a GeoRuby::SimpleFeatures::MultiPolygon" do
          subject.to_georuby.should be_instance_of(GeoRuby::SimpleFeatures::MultiPolygon)
        end
        
        it "should return a MultiPolygon with the same information" do
          subject.to_georuby.should == geometry("MULTIPOLYGON ( ((0 0, 0 1, 1 1, 1 0, 0 0), (0.25 0.25,0 0.75,0.75 0.75,0.75 0.25, 0.25 0.25)), ((15 5, 40 10, 10 20, 5 10, 15 5)) )")
        end
        
      end
      
    end    
    
  end
end
