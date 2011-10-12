require 'spec_helper'

describe GeoRuby::SimpleFeatures::MultiLineString do

  describe "locate_point" do
    
    context "examples" do

      it "should find 2,1 at 0.5 between 0,0 and 4,0" do
        multi_line_string("(0 0,4 0)").locate_point(point(2,1)).should == 0.5
      end

      it "should find 2,1 at 1.5 for (0,4)...(0,1) and (0,0)...(4,0)" do
        multi_line_string("(0 4,0 1),(0 0,4 0)").locate_point(point(2,1)).should == 1.5
      end
    
    end

  end

  describe "interpolate_point" do
    
    context "examples" do

      it "should find 0.5 at (2,0) between 0,0 and 4,0" do
        multi_line_string("(0 0,4 0)").interpolate_point(0.5).should == point(2,0)
      end

      it "should find 1.5 at (2,0) for (0,4)...(0,1) and (0,0)...(4,0)" do
        multi_line_string("(0 4,0 1),(0 0,4 0)").interpolate_point(1.5).should == point(2,0)
      end
      
    end

  end

end

describe GeoRuby::SimpleFeatures::LineString do

  describe "locate_point" do
    
    context "examples" do

      it "should find 2,1 at 0.5 between 0,0 and 4,0" do
        line_string("0 0,4 0").locate_point(point(2,1)).should == 0.5
      end

      it "should find 2,1 at 0.5 between 0,0 and 4,0 (with several segments)" do
        line_string("0 0,2 0,4 0").locate_point(point(2,1)).should == 0.5
      end
      
    end

  end


end

describe GeoRuby::SimpleFeatures::LineString::PointLocator do

  alias_method :p, :point

  def locator(target, departure, arrival)
    GeoRuby::SimpleFeatures::LineString::PointLocator.new target, departure, arrival
  end
  
  context "examples" do

    it "should locate 0,y at 0 between 0,0 and 4,0" do
      -10.upto(10) do |y|
        locator(p(0,y), p(0,0), p(4,0)).locate_point.should be_zero
      end
    end

    it "should locate 2,y at 0.5 between 0,0 and 4,0" do
      -10.upto(10) do |y|
        locator(p(2,y), p(0,0), p(4,0)).locate_point.should == 0.5
      end
    end

    it "should locate 4,y at 1 between 0,0 and 4,0" do
      -10.upto(10) do |y|
        locator(p(4,y), p(0,0), p(4,0)).locate_point.should == 1
      end
    end

    it "should find 2,y at a distance of y from 0,0 and 4,0" do
      -10.upto(10) do |y|
        locator(p(2,y), p(0,0), p(4,0)).distance_from_segment.should be_within(0.001).of(y.abs)
      end
    end

  end

end
