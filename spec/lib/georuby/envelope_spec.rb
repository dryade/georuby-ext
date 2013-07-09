require 'spec_helper'

describe GeoRuby::SimpleFeatures::Envelope do  

  subject { envelope point(0,0), point(1,1) }

  describe "#to_google" do
    
    it "should return an Envelope with Google srid" do
      subject.to_google.srid.should == 900913
    end

  end

  describe "to_polygon" do
    let(:geo_polygon){ polygon(point(0,0), point(0,1), point(1,1), point(1,0), point(0,0))}
    let(:geo_envelope) { envelope( point(0,0), point(1,1) ) }

    it "should return a polygon GeoRuby::SimpleFeatures::Polygon" do
      (geo_envelope.to_polygon == geo_polygon).should be_true 
    end                      
  end

  describe ".bounds" do

    it "should return a global bounds of children" do      
      geometries = [polygon("(0 0,1 1,1 0, 0 0)"), polygon("(1 1,2 2,2 0, 1 1)")]
      GeoRuby::SimpleFeatures::Envelope.bounds(geometries).should == envelope("0 0","2 2")
    end                
  end

  describe ".overlaps?" do

    it "should return true if bound is included in envelope" do      
      bound = envelope("0 0","1 1")      
      envelope("0 0","2 2").overlaps?(bound).should == true
    end                

    it "should return true if bound intersects envelope" do      
      bound = envelope("0 0","1 1")      
      envelope("0.5 0.5","2 2").overlaps?(bound).should == true
    end                
  end


end
