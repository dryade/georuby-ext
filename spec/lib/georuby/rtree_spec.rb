require 'spec_helper'

describe GeoRuby::Rtree::STRBuilder do 

  subject { GeoRuby::Rtree::STRBuilder.new points("0 2,1 1,2 0").reverse }

  let(:element) { "element" }

  def slice(points)
    GeoRuby::Rtree::STRBuilder::Slice.new points(points)
  end

  def node(*children)
    children = points(children.first) if children.size == 1 and String === children.first
    GeoRuby::Rtree::Node.new children
  end

  describe "#root_node" do

    it "should return ..." do
      subject.root_node.should == node(node("1 1, 0 2"), node("2 0"))
    end

  end

  describe "#leaf_nodes" do
    it "should return nodes from slices" do
      subject.stub :slices => [ slice("0 2, 1 1"), slice("2 0") ]
      subject.leaf_nodes.should == [ node("1 1, 0 2"), node("2 0") ]
    end
  end

  describe "#slices" do
    it "should fill slices with sorted elements (by x)" do
      subject.slices.should == [ slice("0 2, 1 1"), slice("2 0") ]
    end                   

    it "should return slices with specified size" do
      subject.slices.each do |slice|
        slice.size.should <= subject.slice_size
      end
    end
  end

  describe "#leaf_nodes_count" do

    it "should return 10 for 39 elements with a node size of 4" do
      GeoRuby::Rtree::STRBuilder.new([element] * 39, 4).leaf_nodes_count.should == 10
    end

  end

  describe "#slice_size" do
                       
    it "should return 3 for 27 elements with a node size of 3" do
      GeoRuby::Rtree::STRBuilder.new([element] * 27, 3).slice_size.should == 3
    end

    it "should return 4 for 30 elements with a node size of 3" do
      GeoRuby::Rtree::STRBuilder.new([element] * 30, 3).slice_size.should == 4
    end
    
  end

end   


describe GeoRuby::Rtree::STRBuilder::Slice do 

  subject { GeoRuby::Rtree::STRBuilder::Slice.new points("2 0,1 1,0 2").reverse, 2 }

  describe "#sort_y" do

    it "should return elements classified by y" do
      subject.sort_y.should == points("2 0, 1 1, 0 2")
    end                      

  end

  describe "#nodes" do

    def node(points)
      GeoRuby::Rtree::Node.new points(points)
    end

    it "should fill nodes with sorted elements" do
      subject.nodes.should == [ node("2 0, 1 1"), node("0 2") ]
    end                      

    it "should return nodes with specified size" do
      subject.nodes.each do |node|
        node.size.should <= subject.node_size
      end
    end

  end

end

describe GeoRuby::Rtree::Node do 

  describe "bounds" do

    it "should return a global bounds of children" do
      subject.children << polygon("(0 0,1 1,1 0,0 0)") 
      subject.children << polygon("(1 1,2 2,2 0,1 1)") 

      subject.bounds.should == envelope("0 0","2 2")
    end                      

  end

  describe "#==" do
    
    it "should be true when children are the same" do
      GeoRuby::Rtree::Node.new(1,2,3).should == GeoRuby::Rtree::Node.new(1,2,3)
    end
               
  end

  # describe "#containing" do
  #   bound = envelope("0 0","1 1")
  #   let(:children) { [ polygon("(0 0,0 1,1 1,1 0,0 0)"), polygon("(0 0,0 2,2 2,2 0,0 0)"), polygon("(0 0,0 0.5,0.5 0.5,0.5 0,0 0)") ] }
    
  #   it "should return elements if containing bounds" do
  #     GeoRuby::Rtree::Node.new(children).containing(bound).should == children
  #   end
               
  # end


end
