class GeoRuby::SimpleFeatures::LineString

  def change(options)
    self.class.from_points(options[:points] || points, 
                           options[:srid] || srid,
                           options[:with_z] || with_z, 
                           options[:with_m] || with_m)
    # or instead of || requires parenthesis
  end

  def reverse
    change :points => points.reverse
  end

  def to_wgs84
    change :points => points.map(&:to_wgs84), :srid => 4326
  end

  def self.merge(lines)
    merged_points = lines.map(&:points).flatten.uniq
    if merged_points.size > 1
      from_points merged_points, lines.first.srid, lines.first.with_z, lines.first.with_m
    end
  end
  
  def to_rgeo
    RGeo::Geos::factory(:srid => srid).line_string(points.collect(&:to_rgeo))
  end

  def ==(other)
    other.respond_to?(:points) and points == other.points
  end

  alias_method :closed?, :is_closed

  def to_ring
    ring_points = closed? ? points : points + [first]
    GeoRuby::SimpleFeatures::LinearRing.from_points ring_points, srid, with_z, with_m
  end

end
