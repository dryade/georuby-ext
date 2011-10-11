module GeoRuby::SimpleFeatures::Geometry

  def inspect
    "#<#{self.class}:#{object_id} \"#{as_ewkt}>\""
  end
  
  alias_method :to_ewkt, :as_ewkt

end
