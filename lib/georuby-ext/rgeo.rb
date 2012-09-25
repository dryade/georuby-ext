class RGeo::Geos::FFIPointImpl
  def to_georuby
    GeoRuby::SimpleFeatures::Point.from_x_y x, y, srid
  end
end

class RGeo::Geos::FFILineStringImpl
  def to_georuby
    GeoRuby::SimpleFeatures::LineString.from_points points.collect(&:to_georuby), srid
  end
end

class RGeo::Geos::FFILinearRingImpl
  def to_georuby
    GeoRuby::SimpleFeatures::LinearRing.from_points points.collect(&:to_georuby), srid
  end
end

class RGeo::Geos::FFIPolygonImpl
  def to_georuby
    GeoRuby::SimpleFeatures::Polygon.from_linear_rings [exterior_ring.to_georuby] + interior_rings.map(&:to_georuby), srid
  end
end

class RGeo::Geos::FFIMultiPolygonImpl
  def to_georuby
    GeoRuby::SimpleFeatures::MultiPolygon.from_polygons collect(&:to_georuby), srid
  end
end

class RGeo::Geos::FFIGeometryCollectionImpl
  def to_georuby
    GeoRuby::SimpleFeatures::GeometryCollection.from_geometries collect(&:to_georuby), srid
  end
end
