require "spec_helper"

describe  GeoRuby::SimpleFeatures::MultiPolygon do  
  
  describe "#to_wgs84" do
    let(:multi_polygon_google) { geometry "MULTIPOLYGON(((0.0 -7.08115455161362e-10,0.0 111325.142866385,111319.490793272 -7.08115455161362e-10,0.0 -7.08115455161362e-10)))", 900913 }
    let(:multi_polygon_wgs84) { geometry "MULTIPOLYGON(((0 0,0 1,1 0,0 0)))" } 
    
    it "should return a polygon in wgs84 coordinates" do
      [multi_polygon_google.to_wgs84.points, multi_polygon_wgs84.points].transpose.each{ |p1,p2|
        p1.x.should be_within(0.0000001).of(p2.x) 
        p1.y.should be_within(0.0000001).of(p2.y)
      }
    end

    it "should return a multi_polygon with wgs84 srid" do
      multi_polygon_google.to_wgs84.srid.should == multi_polygon_wgs84.srid
    end
  end

  describe "#polygons" do
    let(:geo_multi_polygon) { geometry "MULTIPOLYGON(((0 0,0 1,1 1,1 0)), ((0 0,0 1,1 1,1 0)))" } 
    let(:geo_polygon){ polygon("(0 0,0 1,1 1,1 0)") } 

    it "should return an array of polygons" do
      geo_multi_polygon.polygons.should == [geo_polygon, geo_polygon]
    end
  end

  describe "#difference" do    
    let(:g_multi_polygon) { geometry("MULTIPOLYGON (((0 0, 0 1, 1 1, 1 0, 0 0)),  ((0 2, 0 3, 3 3, 2 2, 0 2)))") } 
    let(:empty_geometry_collection) { GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([], 4326) }

    it "should return an empty geometry collection if multi polygons are the same" do
      g_multi_polygon.difference(g_multi_polygon).should == empty_geometry_collection
    end

    it "should return an rgeo polygon if there's only one polygon left' " do
      g_multi_polygon2 = geometry("MULTIPOLYGON (((0 0, 0 1, 1 1, 1 0, 0 0)))") 
      g_multi_polygon.difference(g_multi_polygon2).should == polygon("(0 2, 0 3, 3 3, 2 2)")
    end
    
  end

  describe "#to_rgeo" do
    let(:g_multi_polygon) { geometry("MULTIPOLYGON (((0 0, 0 1, 1 1, 1 0, 0 0)),  ((0 2, 0 3, 3 3, 2 2, 0 2)))") } 
    let(:rg_multi_polygon) { rgeometry("MULTIPOLYGON (((0 0, 0 1, 1 1, 1 0, 0 0)),  ((0 2, 0 3, 3 3, 2 2, 0 2)))") }   

    it "should return an rgeo multi polygons" do
      factory = RGeo::Geos::FFIFactory.new      
      g_multi_polygon.to_rgeo.should == rg_multi_polygon
    end
  end
  
end
