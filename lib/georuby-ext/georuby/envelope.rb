class GeoRuby::SimpleFeatures::Envelope

  def contains_point?(point)
    (lower_corner.x...upper_corner.x).include?(point.x) and
      (lower_corner.y...upper_corner.y).include?(point.y) 
  end

  alias_method :contains?, :contains_point?

  def sql_box
    "SetSRID('BOX3D(#{upper_corner.lng} #{upper_corner.lat}, #{lower_corner.lng} #{lower_corner.lat})'::box3d, #{srid})"
  end

  alias_method :to_sql, :sql_box

  def to_openlayers
    OpenLayers::Bounds.new lower_corner.x, lower_corner.y, upper_corner.x, upper_corner.y
  end

  def to_google
    Envelope.from_points [lower_corner.to_google, upper_corner.to_google],srid, with_z
  end

end
      
