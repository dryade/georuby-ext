class GeoRuby::SimpleFeatures::Envelope
  def to_openlayers
    OpenLayers::Bounds.new lower_corner.x, lower_corner.y, upper_corner.x, upper_corner.y
  end

  def to_google
    Envelope.from_points [lower_corner.to_google, upper_corner.to_google],srid, with_z
  end
end
      
