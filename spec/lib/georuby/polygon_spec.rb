require 'spec_helper'

describe GeoRuby::SimpleFeatures::Polygon do    

  describe "circle" do
    
    let(:center) { point 1,1 }
    let(:radius) { 1000 }
    let(:sides) { 8 }
    
    def circle(arguments = {})
      arguments = { :center => center, :radius => radius, :sides => sides }.merge(arguments)
      GeoRuby::SimpleFeatures::Polygon.circle *arguments.values_at(:center, :radius, :sides)
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
        point.spherical_distance(center).should be_within(0.0001).of(radius)
      end  
    end

    it "should have the same distance between all its points" do
      average_distance = circle.perimeter / circle.side_count
      circle.points.each_cons(2) do |point, next_point|
        point.spherical_distance(next_point).should be_within(0.01).of(average_distance)
      end
    end
  end

  describe "#project_to" do

    let(:target_srid) { 900913 }
    subject { polygon("(0 0,1 1,1 0)") }

    it "should project all rings into wgs84" do
      subject.project_to(target_srid).rings.each_with_index do |ring, index|
        ring.should == subject[index].project_to(target_srid)
      end
    end

    it "should have the target srid" do
      subject.project_to(target_srid).srid.should == target_srid
    end

    it "should not change other attributes" do
      subject.project_to(target_srid).should have_same(:with_z, :with_m).than(subject)
    end

  end

  describe "to_rgeo" do   

    it "should return a rgeo polygon" do
      rgeo_polygon =  rgeometry("POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))")    
      geo_polygon = geometry("POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))") 
      geo_polygon.to_rgeo.should == rgeo_polygon
    end

    it "should return a rgeo polygon with an hole" do
      rgeo_polygon =  rgeometry("POLYGON((0 0, 0 5, 5 5, 5 0, 0 0), (1 1, 2 1, 2 2, 1 2, 1 1))")    
      geo_polygon = geometry("POLYGON((0 0, 0 5, 5 5, 5 0, 0 0), (1 1, 2 1, 2 2, 1 2, 1 1) )") 
      geo_polygon.to_rgeo.should == rgeo_polygon
    end

  end
  
  describe "centroid" do
    let(:georuby_polygon){ geometry("POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))") }      
    
    it "should return centroid for a polygon" do
      georuby_polygon.centroid.should == point(1,1)
    end
    
  end


  describe "union" do
     
    let(:georuby_polygon) { geometry("POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))") }            

    it "should return the same polygon than in input" do   
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon]).should == georuby_polygon
    end
    
    it "should return union of 2 polygons which have a common side" do
      result =  geometry("POLYGON((0.0 0.0,0.0 2.0,0.0 4.0,2.0 4.0,2.0 2.0,2.0 0.0,0.0 0.0))")
      georuby_polygon2 = geometry("POLYGON((0 2, 0 4, 2 4, 2 2, 0 2))")
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon2]).should == result
    end

    it "should return 2 polygons which have an area in common" do
      result =  geometry("POLYGON((0 0,0 1,0 2,0 4,2 4,2 2,2 1,2 0,0 0))")
      georuby_polygon2 = geometry("POLYGON((0 1, 0 4, 2 4, 2 1, 0 1))")
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon2]).should == result
    end

    it "should return 2 polygons which have no intersection" do
      result =  geometry("MULTIPOLYGON( ((0 0, 0 2, 2 2, 2 0, 0 0)), ((3 3, 3 4, 4 4, 4 3, 3 3)) )")
      georuby_polygon2 = geometry("POLYGON((3 3, 3 4, 4 4, 4 3, 3 3))")
      GeoRuby::SimpleFeatures::Polygon.union([georuby_polygon, georuby_polygon2]).should == result
    end
    
  end

  describe "intersect" do
    let(:georuby_polygon){ polygon("(0 0,0 2,2 2,2 0,0 0)")  }      
    let(:georuby_polygon2){ polygon("(0 0,0 4,2 4,2 0,0 0)") }   
    
    it "should return intersect of polygons" do
      test = GeoRuby::SimpleFeatures::Polygon.intersection([georuby_polygon, georuby_polygon2])
      GeoRuby::SimpleFeatures::Polygon.intersection([georuby_polygon, georuby_polygon2]).text_representation.should == georuby_polygon.text_representation
    end
  end

  describe "#difference" do
    let(:georuby_polygon) {  polygon("(0 0,0 2,2 2,2 0,0 0)")  }      
    let(:georuby_polygon2){  polygon("(0 0,0 1,2 1,2 0,0 0)") }    
    
    it "should be empty geometry collection if polygons are the same" do
      georuby_polygon.difference(georuby_polygon).should == GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([], 4326)
    end

    it "should return  polygon('(0 1,0 2,2 2,2 1,0 1)' as result" do
      result =  polygon("(0 1,0 2,2 2,2 1,0 1)")
      georuby_polygon.difference(georuby_polygon2).should == result
    end

    it "should be empty geometry collection if polygon is smaller than the other" do
      georuby_polygon2.difference(georuby_polygon).should == GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([], 4326)
    end

    it "should return a result if we make difference with a multi polygon" do
      geo_polygon = geometry("POLYGON ((0 0, 0 5, 5 5, 5 0, 0 0))")
      geo_multi_polygon = geometry("MULTIPOLYGON ( ((1 1, 2 1, 2 2, 1 2, 1 1)), ((3 3, 4 3, 4 4, 3 4, 3 3)) )")
      geo_polygon.difference(geo_multi_polygon).should ==  geometry("POLYGON ( ((0 0, 0 5, 5 5, 5 0, 0 0), (1 1, 2 1, 2 2, 1 2, 1 1), (3 3, 4 3, 4 4, 3 4, 3 3)) )")
    end

  end

  describe "#==" do
    
    it "should be true when points are same" do
      geometry("POLYGON((0 0,0 1,2 1,2 0,0 0))").should == geometry("POLYGON((0 0,0 1,2 1,2 0,0 0))")
    end

  end

  describe "side_count" do
    
    it "should return 3 for a triangle" do
      polygon("(0 0,1 0,0 1,0 0)").side_count.should == 3
    end

  end
  
end
