require 'spec_helper'

describe GeoRuby::SimpleFeatures::LineString do

  subject { line_string "0 0,1 1,0 0" }

  describe "#to_rgeo" do
    it "should create a RGeo Geos geometry" do
      subject.to_rgeo.should be_kind_of(RGeo::Geos::GeometryImpl)
    end

    context "returned RGeo LineString" do
      it "should have the same srid" do
        subject.to_rgeo.srid.should == subject.srid
      end
      it "should have the points" do
        line_string("0 0,1 1,0 0").to_rgeo.should == rgeo_line_string("0 0,1 1,0 0")
      end
    end 
  end

  describe "#==" do
    
    it "should be true when points are same" do
      line_string("0 0,1 1").should == line_string("0 0,1 1")
    end

    it "should be true when the other is LineRing with the same points" do
      line_string("0 0,1 1,0 0").should == line_string("0 0,1 1,0 0").to_ring
    end

  end

  describe "#to_ring" do

    it "should be a GeoRuby::SimpleFeatures::LinearRing" do
      subject.to_ring.should be_instance_of(GeoRuby::SimpleFeatures::LinearRing)
    end
    
    context "returned LinearRing" do
      
      it "should have the same srid" do
        subject.to_ring.should have_same(:srid).than(subject)
      end

      context "when line is closed" do
        subject { line_string("0 0,1 1,0 0") }

        it "should have the same points" do
          subject.to_ring.points.should == subject.points
        end
      end

      context "when line isn't closed" do
        subject { line_string("0 0,1 1") }

        it "should have the line points and the first one" do
          subject.to_ring.points.should == (subject.points << subject.first)
        end
      end
                              
    end

  end

  describe "#change" do

    let(:other_points) { subject.points + points("3 3") }
    
    it "should change the points if specified" do
      subject.change(:points => other_points).points.should == other_points
    end

    it "should change the srid if specified" do
      subject.change(:srid => 1).srid.should == 1
    end

    it "should not change unspecified attributes" do
      subject.change(:points => other_points).should have_same(:srid, :with_z, :with_m).than(subject)
    end

  end

  describe "#reverse" do
    
    it "should return a LineString with reversed points" do
      subject.reverse.points.should == subject.points.reverse
    end

    it "should not change other attributes" do
      subject.reverse.should have_same(:srid, :with_z, :with_m).than(subject)
    end

  end

  describe "#project_to" do

    let(:target_srid) { 900913 }
    subject { line_string("0 0,1 1,0 0") }

    it "should project all points into wgs84" do
      subject.project_to(target_srid).points.each_with_index do |point, index|
        point.should == subject[index].project_to(target_srid)
      end
    end

    it "should have the target srid" do
      subject.project_to(target_srid).srid.should == target_srid
    end

    it "should not change other attributes" do
      subject.project_to(target_srid).should have_same(:with_z, :with_m).than(subject)
    end

  end

  describe "#close!" do
    
    it "should add first point if needed" do
      line_string("0 0,1 1").close!.should == line_string("0 0,1 1,0 0")
    end

    it "should not change a closed line" do
      line_string("0 0,1 1,0 0").close!.should == line_string("0 0,1 1,0 0")
    end

  end

  describe "#side_count" do
    
    it "should return point count minus one" do
      line_string("0 0,1 1,2 2").side_count.should == 2
    end

  end

end

