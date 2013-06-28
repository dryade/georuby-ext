require "spec_helper"

describe Proj4::Projection do
  
  describe ".for_srid" do
    
    it "should return wgs84 projection for srid 4326" do
      Proj4::Projection.for_srid(4326).should == Proj4::Projection.wgs84
    end

    it "should return wgs84 projection for srid 900913" do
      Proj4::Projection.for_srid(900913).should == Proj4::Projection.google
    end

    it "should return built projection projection for srid 27572" do
      Proj4::Projection.for_srid(27572).definition.include?('epsg:27572').should be_true
    end

    it "should raise an error when srid isn't supported" do
      lambda do
        Proj4::Projection.for_srid(123)
      end.should raise_error
    end

  end


end
