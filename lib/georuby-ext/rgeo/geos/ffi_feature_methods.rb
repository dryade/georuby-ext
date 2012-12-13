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
