class GeoRuby::SimpleFeatures::LinearRing

  class << self
    def from_points_with_close_support(*arguments)
      from_points_without_close_support(*arguments).close!
    end
    alias_method_chain :from_points, :close_support

    def from_coordinates_with_close_support(*arguments)
      from_coordinates_without_close_support(*arguments).close!
    end
    alias_method_chain :from_coordinates, :close_support
  end

  def to_rgeo
    rgeo_factory.linear_ring(points.collect(&:to_rgeo))
  end

end
