class GeoRuby::SimpleFeatures::MultiPolygon
  def to_wgs84
    self.class.from_polygons(self.polygons.collect(&:to_wgs84), 4326)
  end

  def to_google
    self.class.from_polygons(self.polygons.collect(&:to_google), 900913)
  end

  def polygons
    self.geometries
  end

  def difference(georuby_multi_polygon)
    multi_polygon_difference = georuby_multi_polygon.present? ? self.to_rgeo.difference(georuby_multi_polygon.to_rgeo) : self.to_rgeo
    multi_polygon_difference.to_georuby
  end

  def to_rgeo
    rgeo_factory.multi_polygon(polygons.collect(&:to_rgeo))
  end

end
