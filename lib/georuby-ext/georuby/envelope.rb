class GeoRuby::SimpleFeatures::Envelope

  def contains_point?(point)
    (lower_corner.x...upper_corner.x).include?(point.x) and
      (lower_corner.y...upper_corner.y).include?(point.y) 
  end

  def overlaps?(bound)
    contains_point?(bound.upper_corner) or contains_point?(bound.lower_corner) or bound.contains_point?(upper_corner) or bound.contains_point?(lower_corner)   
  end

  def self.bounds(geometries)
    return nil if geometries.blank?

    geometries.inject(geometries.first.envelope) do |envelope, geometry|
      envelope.extend!(geometry.envelope)
    end
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

  def to_polygon
    GeoRuby::SimpleFeatures::Polygon.from_coordinates( [ [ [lower_corner.x, lower_corner.y], [lower_corner.x, upper_corner.y], [upper_corner.x, upper_corner.y], [upper_corner.x, lower_corner.y] ] ] ) 
  end

  def to_rgeo
    self.to_polygon.to_rgeo
  end

end
      
