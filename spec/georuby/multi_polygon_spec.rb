require "spec_helper"

describe  GeoRuby::SimpleFeatures::MultiPolygon do
  
  describe "#to_wgs84" do
    let(:multi_polygon_google) { geometry "MULTIPOLYGON(((0.0 -7.08115455161362e-10,0.0 111325.142866385,111319.490793272 -7.08115455161362e-10,0.0 -7.08115455161362e-10)))", 900913 }
    let(:multi_polygon_wgs84) { geometry "MULTIPOLYGON(((0 0,0 1,1 0,0 0)))" } 
    
    it "should return a polygon in wgs84 coordinates" do
      multi_polygon_google.to_wgs84.should == multi_polygon_wgs84
    end

    it "should return a multi_polygon with wgs84 srid" do
      multi_polygon_google.to_wgs84.srid.should == multi_polygon_wgs84.srid
    end
  end

  describe "#polygons" do
    let(:georuby_polygon){ polygon(point(0.0,0.0), point(0.0,2.0), point(2.0,2.0), point(2.0,0.0), point(0.0,0.0))} 
    let(:georuby_multi_polygon){multi_polygon(georuby_polygon, georuby_polygon)}  
    it "should return an array of polygons" do
      georuby_multi_polygon.polygons.should == [georuby_polygon, georuby_polygon]
    end
  end
  
end
