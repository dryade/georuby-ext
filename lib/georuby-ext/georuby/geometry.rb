class GeoRuby::SimpleFeatures::Geometry

  def inspect
    "#<#{self.class}:#{object_id} \"#{to_ewkt}>\""
  end
  
  alias_method :to_ewkt, :as_ewkt

  def wgs84?
    srid == 4326
  end

end
