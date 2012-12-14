require "spec_helper"

describe GeoRuby::SimpleFeatures::LinearRing do
  let(:result) {factory = RGeo::Geos::FFIFactory.new
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

  describe ".from_points" do
    
    it "should be closed even if last point is missing" do
      GeoRuby::SimpleFeatures::LinearRing.from_points(points("0 0,1 1,0 0")).should be_closed
    end

    it "should accept already closed line" do
      GeoRuby::SimpleFeatures::LinearRing.from_points(points("0 0,1 1,0 0")).should == line_string("0 0,1 1,0 0")
    end

  end

  describe ".from_coordinates" do
    
    it "should be closed even if last point is missing" do
      GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[0,0],[1,1],[0,0]]).should be_closed
    end

    it "should accept already closed line" do
      GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[0,0],[1,1],[0,0]]).should == line_string("0 0,1 1,0 0")
    end

  end

  it "should close linear rings parsed from ekt" do
    polygon("(0 0,1 1)").rings.first.should be_closed
  end

  it "should close linear rings parsed from ekb" do
    ewkb_polygon = GeoRuby::SimpleFeatures::Geometry.from_ewkb(polygon("(0 0,1 1,0 0)").as_ewkb)
    ewkb_polygon.rings.first.should be_closed
  end

end
