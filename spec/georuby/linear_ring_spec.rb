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
  
end
