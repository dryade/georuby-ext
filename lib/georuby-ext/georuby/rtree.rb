module GeoRuby
  class Rtree
    attr_accessor :root

    def initialize(root)
      @root = root
    end

    def self.bulk_loading(elements, options = {})
      options = { :node_size => 2 }.merge(options)
      STRBuilder.new(elements, options[:node_size]).to_rtree
    end

    delegate :containing, :to => :root

    class STRBuilder
      attr_accessor :elements, :node_size
      
      def initialize(elements, node_size = 2)
        @elements = elements
        @node_size = node_size
      end

      def to_rtree
        Rtree.new root_node
      end

      def leaf_nodes
        slices.collect(&:nodes).flatten
      end

      def root_node
        nodes = leaf_nodes

        while nodes.many?
          nodes = [].tap do |parent_nodes|
            nodes.each_slice(node_size) do |children|
              parent_nodes << Node.new(children)
            end
          end
        end

        nodes.first
      end

      def slices
        puts slice_size
        [].tap do |slices|
          sort_x.each_slice(slice_size) do |slice_elements|
            slices << Slice.new(slice_elements, node_size)
          end
        end
      end

      def sort_x
        elements.sort_by do |element|
          element.bounds.center.x
        end
      end

      def leaf_nodes_count
        (elements.count / node_size.to_f).ceil
      end

      def slice_size
        Math.sqrt(leaf_nodes_count).ceil
      end
      
      class Slice

        attr_accessor :elements, :node_size

        def initialize(elements, node_size = 2)
          @elements, @node_size = elements, node_size
        end

        delegate :size, :to => :elements

        def sort_y
          elements.sort_by do |element|
            element.bounds.center.y
          end
        end

        def nodes
          [].tap do |nodes|
            sort_y.each_slice(node_size) do |node_elements|
              nodes << Node.new(node_elements)
            end
          end
        end

        def ==(other)
          other.respond_to?(:elements) and elements == other.elements
        end

      end

    end
    
    class Node
      attr_accessor :children

      def initialize(*children)
        @children = children.flatten
      end

      def bounds
        @bounds ||= GeoRuby::SimpleFeatures::Envelope.bounds(children)
      end
      alias_method :envelope, :bounds

      delegate :size, :to => :children

      def ==(other)
        other.respond_to?(:children) and children == other.children
      end

      def containing(bounds)
        children.select do |child|
          child.bounds.overlaps?(bounds) 
        end.collect do |child|
          if child.respond_to?(:containing)
            child.containing(bounds)
          else
            child
          end
        end.flatten
      end

    end

  end
end
