module RGeo
  module Geos
    module FFIGeometryMethods
      
      def to_georuby
        if self.class == FFIPointImpl
          GeoRuby::SimpleFeatures::Point.from_x_y x, y, srid
        elsif self.class == FFILineStringImpl
          GeoRuby::SimpleFeatures::LineString.from_points points.collect(&:to_georuby), srid     
        elsif self.class == FFILinearRingImpl
          GeoRuby::SimpleFeatures::LinearRing.from_points points.collect(&:to_georuby), srid
        elsif self.class == FFIPolygonImpl
          GeoRuby::SimpleFeatures::Polygon.from_linear_rings linear_rings.collect(&:to_georuby), srid
        else
          GeoRuby::SimpleFeatures::Geometry.from_geometry collect(&:to_georuby), srid
        end      
        
      end    
      
    end 
    
    module FFIGeometryCollectionMethods
      alias_method :geometries, :each

      def to_georuby
        if self.class == FFIMultiPolygonImpl
          GeoRuby::SimpleFeatures::MultiPolygon.from_polygons collect(&:to_georuby), srid
        else
          GeoRuby::SimpleFeatures::GeometryCollection.from_geometries collect(&:to_georuby), srid
        end
      end
    end 

    module FFILineStringMethods      

      def to_linear_ring
        linear_ring_points = points.first == points.last ? points : points.push(points.first)
        factory.linear_ring linear_ring_points
      end

      def locate_point(target)
        distance_on_line(target) / length
      end

      def distance_on_line(target)
        nearest_locator = nearest_locator(target)
        nearest_locator.distance_on_segment + nearest_locator.segment.line_distance_at_departure
      end

      def distance_from_line(target)
        nearest_locator(target).distance_from_segment
      end

      def nearest_locator(target)
        locators(target).min_by(&:distance_from_segment)
      end

      def locators(point)
        segments.collect { |segment| segment.locator(point) }
      end

      def segments_without_cache
        previous_point = nil
        distance_from_departure = 0

        
        points.inject([]) do |segments, point|
          Segment.new(previous_point, point).tap do |segment|
            segment.line = self
            segment.line_distance_at_departure = distance_from_departure

            distance_from_departure += segment.distance
            
            segments << segment
          end if previous_point
          
          previous_point = point
          segments
        end
      end

      def segments_with_cache
        @segments ||= segments_without_cache
      end
      alias_method :segments, :segments_with_cache

      def interpolate_point(location)
        return points.last if location >= 1
        return points.first if location <= 0

        distance_on_line = location * spherical_distance

        segment = segments.find do |segment|
          segment.line_distance_at_arrival > distance_on_line
        end

        location_on_segment =
          (distance_on_line - segment.line_distance_at_departure) / segment.distance

        segment.interpolate_point location_on_segment
      end

      class Segment

        attr_reader :departure, :arrival
        
        def initialize(departure, arrival)
          @departure, @arrival = departure, arrival
        end

        attr_accessor :line, :line_distance_at_departure

        def line_distance_at_arrival
          line_distance_at_departure + distance
        end

        def locator(target)
          PointLocator.new target, self
        end

        def location_in_line
          if line and line_distance_at_departure
            line_distance_at_departure / line.length
          end
        end

        def square_of_distance
          distance**2
        end

        def distance
          @distance ||= departure.distance(arrival)
        end

        def to_s
          "#{departure.x},#{departure.y}..#{arrival.x},#{arrival.y}"
        end

        def interpolate_point(location)
          dx, dy = (arrival.x - departure.x) * location, (arrival.y - departure.y) * location
          RGeo::Geos::FFIPoint.from_x_y departure.x + dx, departure.y + dy, line.srid
        end

      end

      class PointLocator
        extend ActiveSupport::Memoizable
        include Math

        attr_reader :target, :segment
        delegate :departure, :arrival, :to => :segment
        
        def initialize(target, segment_or_departure, arrival = nil)
          @segment = 
            if arrival
              Segment.new(segment_or_departure, arrival)
            else
              segment_or_departure
            end
          @target = target

          raise "Target is not defined" unless target
        end

        def distance_from_segment
          return 0 if [segment.departure, segment.arrival].include?(target)          
          Math.sqrt( target_distance_from_departure**2 - target_distance_from_segment**2 )
        end

        def target_distance_from_departure
          departure.distance target
        end

        def target_distance_from_segment
          target.distance(rgeo_factory.line_string([rgeo_factory.point(segment.departure.x, segment.departure.y), rgeo_factory.point(segment.arrival.x,segment.arrival.y) ]))
        end

      end

    end

    module FFIMultiLineStringMethods    

      def locate_point(target)
        nearest_locator = nearest_locator(target)
        nearest_locator.location + nearest_locator.index
      end

      def interpolate_point(location)
        line_index, line_location = location.to_i, location % 1
        if line = geometries[line_index]
          line.interpolate_point(line_location)
        end
      end

      def nearest_locator(target)
        locators(target).min_by(&:distance_from_line)
      end

      def locators(point)
        [].tap do |locators|
          geometries.each_with_index do |line, index| 
            locators << PointLocator.new(point, line, index) 
          end
        end
      end

      class PointLocator

        attr_reader :target, :line, :index

        def initialize(target, line, index)
          @target = target
          @line = line
          @index = index
        end

        def location
          line.locate_point(target)
        end

        def distance_on_line
          line.distance_on_line(target)
        end

        def distance_from_line
          line.distance_from_line(target)
        end

      end

    end

    module FFILinearRingMethods      
      def to_linear_ring
        linear_ring_points = points.first == points.last ? points : points.push(points.first)
        factory.linear_ring linear_ring_points
      end
    end

    module FFIPolygonMethods      
      def rings
        [exterior_ring] + interior_rings
      end
      
      def linear_rings
        rings.collect(&:to_linear_ring)
      end
    end


  end
end
