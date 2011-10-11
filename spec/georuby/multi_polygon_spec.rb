require "spec_helper"

describe  GeoRuby::SimpleFeatures::MultiPolygon do
  
  describe "#to_wgs84" do
    
    let(:polygon_google) {polygon(point(0,0), point(0,1), point(1,0), point(0,0))}
    let(:polygon_wgs84) { GeoRuby::SimpleFeatures::Polygon.from_points([[point(0, 0, 4326), point(0, 0.000008983152840993819, 4326), point(0.000008983152841195214, 0, 4326), point(0, 0, 4326)]], 4326)} 
    let(:multi_polygon_google) {multi_polygon(polygon_google, polygon_google)}
    let(:multi_polygon_wgs84) {GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([polygon_wgs84, polygon_wgs84], 4326)}
    
    it "should return a polygon in wgs84 coordinates" do
      multi_polygon_google.to_wgs84.should == multi_polygon_wgs84
    end

    it "should return same srid" do
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
