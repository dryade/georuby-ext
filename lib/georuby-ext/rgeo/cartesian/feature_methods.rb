module RGeo
  module Cartesian
    module GeometryMethods
      
      def to_georuby
        if self.class == PointImpl
          GeoRuby::SimpleFeatures::Point.from_x_y x, y, srid
        elsif self.class == LineStringImpl
          GeoRuby::SimpleFeatures::LineString.from_points points.collect(&:to_georuby), srid     
        elsif self.class == LinearRingImpl
          GeoRuby::SimpleFeatures::LinearRing.from_points points.collect(&:to_georuby), srid
        elsif self.class == PolygonImpl
          GeoRuby::SimpleFeatures::Polygon.from_linear_rings linear_rings.collect(&:to_georuby), srid
        else
          GeoRuby::SimpleFeatures::Geometry.from_geometry collect(&:to_georuby), srid
        end      
        
      end    
      
    end 
    
    module GeometryCollectionMethods
      def to_georuby
        if self.class == MultiPolygonImpl
          GeoRuby::SimpleFeatures::MultiPolygon.from_polygons collect(&:to_georuby), srid
        else
          GeoRuby::SimpleFeatures::GeometryCollection.from_geometries collect(&:to_georuby), srid
        end
      end
    end 

    module LineStringMethods      
      def to_linear_ring
        linear_ring_points = points.first == points.last ? points : points.push(points.first)
        factory.linear_ring linear_ring_points
      end
    end

    module LinearRingMethods      
      def to_linear_ring
        linear_ring_points = points.first == points.last ? points : points.push(points.first)
        factory.linear_ring linear_ring_points
      end
    end

    module PolygonMethods      
      def rings
        [exterior_ring] + interior_rings
      end
      
      def linear_rings
        rings.collect(&:to_linear_ring)
      end
    end


  end
end
