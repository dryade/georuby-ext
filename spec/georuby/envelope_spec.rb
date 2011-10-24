require 'spec_helper'

describe GeoRuby::SimpleFeatures::Envelope do  

  describe "to_polygon" do
    let(:geo_polygon){ polygon(point(0,0), point(0,1), point(1,1), point(1,0), point(0,0))}
    let(:geo_envelope) { envelope( point(0,0), point(1,1) ) }

    it "should return a polygon GeoRuby::SimpleFeatures::Polygon" do
      (geo_envelope.to_polygon == geo_polygon).should be_true 
    end                      
  end

end
