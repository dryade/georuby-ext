class RGeo::Geos::PointImpl
  def to_georuby
    GeoRuby::SimpleFeatures::Point.from_x_y x, y, srid
  end
end

class RGeo::Geos::LineStringImpl
  def to_georuby
    GeoRuby::SimpleFeatures::LineString.from_points points.collect(&:to_georuby), srid
  end
end

class RGeo::Geos::PolygonImpl
  def to_georuby
    GeoRuby::SimpleFeatures::Polygon.from_linear_rings [exterior_ring.to_georuby], srid
  end
end

class RGeo::Geos::MultiPolygonImpl
  def to_georuby
    GeoRuby::SimpleFeatures::MultiPolygon.from_polygons collect(&:to_georuby), srid
  end
end
