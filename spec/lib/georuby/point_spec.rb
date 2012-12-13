require 'spec_helper'

describe GeoRuby::SimpleFeatures::Point do

  subject { point 1, 2 }

  describe "#==" do

    let(:other) { mock :other, :lat => nil, :lng => nil }
    
    it "should return false if other is nil" do
      subject.should_not == nil
    end

    it "should return true if spherical_distance to other is smaller than 10e-3 (< 1m)" do
      subject.stub :spherical_distance => 10e-4
      subject.should == other
    end

    it "should return false if spherical distance to other is greater or equals to 10e-3 (>= 1m)" do
      subject.stub :spherical_distance => 10e-3
      subject.should_not == other
    end

    it "should match the same point into 2 different srid" do
      subject.to_google.should == subject
    end

  end

  describe "to_rgeo" do
    it "should create a RGeo::Geos::FFIPointImpl" do
      subject.to_rgeo.should be_instance_of(RGeo::Geos::FFIPointImpl)
    end 

    it "should have the same information" do
      subject.to_rgeo.should have_same(:x, :y, :srid).than(subject)
    end
  end

  describe ".centroid" do

    def centroid(points)
      points = points(points) if String === points
      GeoRuby::SimpleFeatures::Point.centroid points
    end
    
    it "should return nil if no points in input" do
      centroid([]).should be_nil
    end
    
    it "should return point in input if only one" do
      centroid("0 0").should == point(0,0)
    end

    it "should return middle if two points in input" do
      centroid("0 0,1 0").should == point(0.5,0)
    end
    
    it "should return centroid of given points" do
      centroid("0 0,0 2,2 2,2 0").should == point(1,1)
    end

    it "should have the same srid than points" do
      google_point = point.to_google
      centroid([google_point]).srid.should == google_point.srid
    end
    
  end

  describe "#to_proj4" do
    
    it "should return a Proj4::Point" do
      subject.to_proj4.should be_instance_of(Proj4::Point)
    end

    it "should use the given ratio (if specified)" do
      subject.to_proj4(10).x.should == subject.x * 10
      subject.to_proj4(10).y.should == subject.y * 10
    end

    context "when Point is wgs84" do

      it "should transform x to radians (using ratio #{Proj4::DEG_TO_RAD})" do
        subject.to_proj4.x.should == subject.x * Proj4::DEG_TO_RAD
      end

      it "should transform y to radians (using ratio #{Proj4::DEG_TO_RAD})" do
        subject.to_proj4.y.should == subject.y * Proj4::DEG_TO_RAD
      end

    end

    it "should have the same z" do
      subject.to_proj4.z.should == nil
    end

  end

  describe ".from_pro4j" do

    let(:proj4_point) { subject.to_proj4 }
    let(:srid) { subject.srid }

    def from_pro4j(point, srid = srid)
      GeoRuby::SimpleFeatures::Point.from_pro4j point, srid
    end

    it "should transform x to degres" do
      from_pro4j(proj4_point).x.should == proj4_point.x * Proj4::RAD_TO_DEG
    end

    it "should transform y to degres" do
      from_pro4j(proj4_point).y.should == proj4_point.y * Proj4::RAD_TO_DEG
    end

    it "should have the specified srid" do
      from_pro4j(proj4_point, srid).srid.should == srid
    end
    
  end

  it "should be used as Hash key" do
    hash = { point(0,0) => :found }
    hash[point(0,0)].should == :found
  end

  describe "#eql?" do
    
    it "should compare x, y, z and srid" do
      point(0,0).should eq(point(0,0))
    end

  end

  describe "hash" do

    it "should use x, y, z and srid" do
      point(0,0).hash.should == point(0,0).hash
    end
    
  end

  describe "to_s" do
    
    it "should contain 'y,x'" do
      point(1,2).to_s.should == "2,1"
    end

  end

  describe "#bounding_box" do

    it "should be itself twice" do
      subject.bounding_box.should == [subject, subject]
    end

    it "should return 3 points with_z" do
      subject.with_z = true
      subject.bounding_box.should == [subject] * 3
    end
    
  end

  describe "#projection" do

    let(:projection) { mock :projection }
    
    it "should return projection associated to srid" do
      Proj4::Projection.should_receive(:for_srid).with(subject.srid).and_return(projection)
      subject.projection.should == projection
    end

  end

  describe "#project_to" do

    let(:tour_eiffel_in_wgs84) { point 2.2946, 48.8580, 4326 }
    let(:tour_eiffel_in_google) { point 255433.703574246, 6250801.22232508, 900913 }

    it "should return the Point when the target srid is the same" do
      subject.project_to(subject.srid).should == subject
    end

    it "should return a Point with the target srid" do
      subject.project_to(900913).srid.should == 900913
    end

    it "should return a Point projected into the target srid" do
      tour_eiffel_in_google.project_to(tour_eiffel_in_wgs84.srid).should be_close_to tour_eiffel_in_wgs84
      tour_eiffel_in_wgs84.project_to(tour_eiffel_in_google.srid).should be_close_to tour_eiffel_in_google
    end

  end

  describe ".bounds" do

    let(:some_points) { points("0 0,1 1,1 0,0 1") }

    it "should return an Envelope with the same srid than points" do
      GeoRuby::SimpleFeatures::Point.bounds(some_points).srid.should == GeoRuby::SimpleFeatures::Point.srid!(some_points)
    end

    it "should return '0 0,1 1' for '0 0,1 1,1 0,0 1'" do
      bounds = GeoRuby::SimpleFeatures::Point.bounds(points('0 0,1 1,1 0,0 1'))
      bounds.lower_corner.should == point(0,0)
      bounds.upper_corner.should == point(1,1)
    end

  end

  describe "#endpoint" do

    let(:distance) { 10000 }
    
    it "should return a point at the given distance" do
      subject.endpoint(rand(360), distance).spherical_distance(subject).should be_within(0.001).of(distance)
    end

    it "should not change longitude when heading is 0 (north)" do
      subject.endpoint(0, distance).should have_same(:lng).than(subject)
    end

    it "should not change latitude when heading is 90 (east)" do
      subject.endpoint(90, distance).lat.should be_within(0.0001).of(subject.lat)
    end

  end

  describe "#change" do
    
    it "should change x if specified" do
      subject.change(:x => 42).x.should == 42
    end

    it "should change y if specified" do
      subject.change(:y => 42).y.should == 42
    end

    it "should change the srid if specified" do
      subject.change(:srid => 1).srid.should == 1
    end

    it "should not change unspecified attributes" do
      subject.change(:x => 1).should have_same(:y, :srid, :with_z, :with_m).than(subject)
    end

  end

end
