require "spec_helper"

describe GeoRuby::SimpleFeatures::LinearRing do
  let(:result) {factory = RGeo::Geos::Factory.create
    factory.linear_ring([factory.point(0, 0), factory.point(2, 1), factory.point(3, 2), factory.point(0, 0)])} 
  
  describe "to_rgeo" do
    it "should create a RGeo::Feature::LinearRing" do
      line = linear_ring(point(0,0), point(2,1), point(3,2), point(0,0))
      line.to_rgeo.should == result
    end 

    # it "should create a RGeo::Feature::LinearRing if the georuby linear ring is not closed" do
    #   line = linear_ring(point(0,0), point(2,1), point(3,2))
    #   line.to_rgeo.should == result
    # end

  end
  
  describe "#to_wgs84" do
    let(:line) {linear_ring(point(0,0), point(1,1), point(0,0))}
    let(:line_wgs84) {    GeoRuby::SimpleFeatures::LinearRing.from_points([point(0,0,4326), point(0.000008983152841195214, 0.000008983152840993819,4326), point(0,0,4326)], 4326)}
    
    it "should return true when we compare line coordinates" do
      line.to_wgs84.should == line_wgs84
    end

    it "should return same srid" do
      line.to_wgs84.srid.should == line_wgs84.srid
    end
  end
  
end
