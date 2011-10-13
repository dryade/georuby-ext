require 'spec_helper'

describe GeoRuby::SimpleFeatures::Polygon do    
  describe "circle" do
    
    let(:center) { point 1,1 }
    let(:radius) { 1000 }
    let(:sides) { 8 }
    
    alias_method :p, :point

    def circle(arguments = {})
      arguments = { :center => center, :radius => radius, :sides => sides }.merge(arguments)
      GeoRuby::SimpleFeatures::Polygon.circle(*arguments.values_at(:center, :radius, :sides))
    end

    it "should create a square" do
      p1 = center.endpoint 0, radius
      p2 = center.endpoint 90, radius
      p3 = center.endpoint 180, radius
      p4 = center.endpoint 270, radius

      circle(:sides => 4).should == polygon(p1, p2, p3, p4, p1)
    end
    
    it "should have the given side count" do
      circle(:sides => 16).side_count.should == 16
    end
    
    it "should be closed" do
      circle(:sides => 16).rings.each do |ring|
        ring.is_closed.should be_true
      end
    end
    
    it "should have all its points as the radius distance of the center" do
      circle.points.all? do |point| 
        point.distance(center).should be_within(0.0001).of(radius)
      end  
    end

    it "should have the same distance between all its points" do
      points = circle.points.dup
      previous = points.shift
      distances = points.collect do |point| 
        previous.euclidian_distance(point).tap do |distance|
          previous = point
        end
      end

      average_distance = distances.sum / distances.size

      distances.each do |distance| 
        distance.should be_within(0.01).of(average_distance)
      end  
    end
  end

  describe "#to_wgs84" do
    let(:polygon_google) { geometry "POLYGON((0.0 -7.08115455161362e-10,0.0 111325.142866385,111319.490793272 -7.08115455161362e-10,0.0 -7.08115455161362e-10))", 900913 }
    let(:polygon_wgs84) { geometry "POLYGON((0 0,0 1,1 0,0 0))" } 
    
    it "should return a polygon in wgs84 coordinates" do
      polygon_google.to_wgs84.should == polygon_wgs84
    end

    it "should return a polygon with wgs84 srid" do
      subject.to_wgs84.srid.should == 4326
    end
  end

  describe "to_rgeo" do
    
    let(:result) {factory = RGeo::Geos::Factory.create
      factory.polygon(factory.line_string([factory.point(0, 0), factory.point(0, 2), factory.point(2, 2), factory.point(2, 0),  factory.point(0, 0)]))}
    
    let(:georuby_polygon){ polygon(point(0,0), point(0,2), point(2,2), point(2,0), point(0,0))}      
    it "should return a polygon RGeo::Feature::Polygon" do
      georuby_polygon.to_rgeo.should == result
    end
  end
  
  describe "centroid" do
    let(:georuby_polygon){ polygon(point(0,0), point(0,2), point(2,2), point(2,0), point(0,0))}      
    
    it "should return centroid for a polygon" do
      georuby_polygon.centroid.should == point(1,1)
    end
    
  end


  describe "union" do
    
    let(:result){ polygon(point(0.0,0.0), point(0.0,2.0), point(0.0,4.0), point(2.0,4.0), point(2.0,2.0), point(2.0,0.0), point(0.0,0.0))}      
    let(:georuby_polygon){ polygon(point(0.0,0.0), point(0.0,2.0), point(2.0,2.0), point(2.0,0.0), point(0.0,0.0))}      
    let(:georuby_polygon2){ polygon(point(0.0,0.0), point(0.0,4.0), point(2.0,4.0), point(2.0,0.0), point(0.0,0.0))}      

    it "should return the same polygon than in input" do
      test = GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon])
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon]).text_representation.should == georuby_polygon.text_representation
    end
    
    it "should return union of polygons" do
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon2]).text_representation.should == result.text_representation
    end
    
  end

  describe "intersect" do
    let(:georuby_polygon){ polygon(point(0.0,0.0), point(0.0,2.0), point(2.0,2.0), point(2.0,0.0), point(0.0,0.0))}      
    let(:georuby_polygon2){ polygon(point(0.0,0.0), point(0.0,4.0), point(2.0,4.0), point(2.0,0.0), point(0.0,0.0))}   
    
    it "should return intersect of polygons" do
      test = GeoRuby::SimpleFeatures::Polygon.intersection([georuby_polygon, georuby_polygon2])
      GeoRuby::SimpleFeatures::Polygon.intersection([georuby_polygon, georuby_polygon2]).text_representation.should == georuby_polygon.text_representation
    end
  end

  describe "#==" do
    
    it "should be true when points are same" do
      geometry("POLYGON((0 0,1 1))").should == geometry("POLYGON((0 0,1 1))")
    end

  end
  
end
