require 'spec_helper'

describe GeoRuby::SimpleFeatures::MultiLineString do

  describe "locate_point" do

    context "examples" do

      # it "should find 2,1 at 0.5 between 0,0 and 4,0" do
      #   multi_line_string("(0 0,4 0)").locate_point(point(2,1)).should == 0.5
      # end

      # it "should find 2,1 at 1.5 for (0,4)...(0,1) and (0,0)...(4,0)" do
      #   multi_line_string("(0 4,0 1),(0 0,4 0)").locate_point(point(2,1)).should == 1.5
      # end
    
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
    
    # context "examples" do

    #   it "should find 2,1 at 0.5 between 0,0 and 4,0" do
    #     line_string("0 0,4 0").locate_point(point(2,1)).should == 0.5
    #   end

    #   it "should find 2,1 at 0.5 between 0,0 and 4,0 (with several segments)" do
    #     line_string("0 0,2 0,4 0").locate_point(point(2,1)).should == 0.5
    #   end
      
    # end

    it "should find Tour Eiffel at 0.434073695339917 on Avenue Gustave Eiffel" do
      tour_eiffel = point 2.2946, 48.8580
      avenue_gustave_eiffel = line_string "2.29406861440145 48.8570391455916,2.29498049424636 48.8576531708278,2.29540512788116 48.8579392878211,2.29634853859254 48.8585744605187"
      expected_location = 0.434073695339917

      avenue_gustave_eiffel.locate_point(tour_eiffel).should be_within(0.001).of(expected_location)
    end

  end

end

describe GeoRuby::SimpleFeatures::LineString::PointLocator do

  alias_method :p, :point

  def locator(target, departure, arrival)
    GeoRuby::SimpleFeatures::LineString::PointLocator.new target, departure, arrival
  end

  describe "distance_from_segment" do

    it "should be zero if target is the segment departure" do
      departure = point(0, 0)
      locator(departure, departure, p(1,1)).distance_from_segment.should be_zero
    end

    it "should be zero if target is the segment arrival" do
      arrival = point(0, 0)
      locator(arrival, p(1,1), arrival).distance_from_segment.should be_zero
    end

  end
  
  context "examples" do

    it "should find right angle between 3 points" do
      origin = tour_eiffel = point(2.2946, 48.8580)
      locator(origin.endpoint(45, 100), origin, origin.endpoint(90, 100)).angle.rad2deg.should be_within(0.001).of(45)
    end

    # it "should locate 0,y at 0 between 0,0 and 4,0" do
    #   -10.upto(10) do |y|
    #     locator(p(0,y), p(0,0), p(4,0)).locate_point.should be_zero
    #   end
    # end

    # it "should locate 2,y at 0.5 between 0,0 and 4,0" do
    #   -10.upto(10) do |y|
    #     locator(p(2,y), p(0,0), p(4,0)).locate_point.should == 0.5
    #   end
    # end

    # it "should locate 4,y at 1 between 0,0 and 4,0" do
    #   -10.upto(10) do |y|
    #     locator(p(4,y), p(0,0), p(4,0)).locate_point.should == 1
    #   end
    # end

    # it "should find 2,y at a distance of y from 0,0 and 4,0" do
    #   -10.upto(10) do |y|
    #     locator(p(2,y), p(0,0), p(4,0)).distance_from_segment.should be_within(0.001).of(y.abs)
    #   end
    # end

  end


end
