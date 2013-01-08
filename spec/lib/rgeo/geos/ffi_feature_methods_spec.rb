require "spec_helper"

module RGeo
  module Geos

    describe FFIPointImpl do
      
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
    
    describe FFILineStringImpl do
      
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

      describe "#distance_on_line" do
        
        it "should return distance on line" do
          #subject.stub :nearest_locator => 
          #subject.distance_on_line().should == 
        end

      end

      describe "#distance_from_line" do
        
        it "should return distance from line" do
          #subject.distance_from_line().should == 
        end

      end
      
    end

    describe RGeo::Geos::FFILineStringImpl::Segment do
      subject { RGeo::Geos::FFILineStringImpl::Segment.new(rgeo_point(0, 1), rgeo_point(0, 2)) }

      before :each do 
        subject.stub :line_distance_at_departure => 1
        subject.stub :line => rgeometry("LINESTRING(0 0, 0 1, 0 2)")
      end
      
      describe "#line_distance_at_arrival" do
        it "should return distance between departure and arrival for Segment" do
          subject.line_distance_at_arrival.should == 2
        end

        it "should return distance between departure and arrival for Segment and line distance" do
          subject.stub :line_distance_at_departure => 0
          subject.line_distance_at_arrival.should == 1
        end
      end

      describe "#location_in_line" do
        it "should return the distance at the beginning of the segment" do
          subject.location_in_line.should == 0.5
        end
      end
      
    end

    describe RGeo::Geos::FFILineStringImpl::PointLocator do

      let(:departure) { rgeo_point(0, 0) }
      let(:arrival) { rgeo_point(2, 0) }
      let(:point_on_segment) { rgeo_point(1, 0) }
      
      def locator(target, departure, arrival)
        RGeo::Geos::FFILineStringImpl::PointLocator.new target, departure, arrival
      end

      describe "distance_from_segment" do

        it "should be zero if target is on the segment" do
          locator(departure, departure, arrival).distance_from_segment.should be_zero
        end

        it "should be 1 if target is on the middle of the segment" do
          locator(point_on_segment, departure, arrival).distance_from_segment.should == 1.0
        end

        it "should be 1 if target is on the x axis of the middle of the segment" do
          locator(rgeo_point(1,1), departure, arrival).distance_from_segment.should be_within(0.01).of(1.0)
        end

      end

    end
      
      # describe RGeo::Geos::FFILinearRingImpl do

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
      
    describe FFIPolygonImpl do
      
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
    
    describe RGeo::Geos::FFIMultiLineStringImpl do
      
      describe "locate_point" do
        
        context "examples" do
          
          # it "should find 2,1 at 0.5 between 0,0 and 4,0" do
          #   multi_line_string("(0 0,4 0)").locate_point(point(2,1)).should == 0.5
          # end

          # it "should find 2,1 at 1.5 for (0,4)...(0,1) and (0,0)...(4,0)" do
          #   multi_line_string("(0 4,0 1),(0 0,4 0)").locate_point(point(2,1)).should == 1.5
          # end
          
        end

      end

      # describe "interpolate_point" do
      
      #   context "examples" do

      #     it "should find 0.5 at (2,0) between 0,0 and 4,0" do
      #       rgeometry("MULTILINESTRING((0 0,4 0))").interpolate_point(0.5).should == point(2,0)
      #     end

      #     it "should find 1.5 at (2,0) for (0,4)...(0,1) and (0,0)...(4,0)" do
      #       rgeometry("MULTILINESTRING((0 4,0 1),(0 0,4 0))").interpolate_point(1.5).should == point(2,0)
      #     end
      
      #   end

      # end

    end

    
    describe FFIMultiPolygonImpl do
      
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
