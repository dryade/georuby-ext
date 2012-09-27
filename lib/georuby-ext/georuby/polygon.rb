class GeoRuby::SimpleFeatures::Polygon

  def self.circle(center, radius, sides_number = 24)
    points = sides_number.times.map do |side|
      2 * 180 / sides_number * side
    end.map! do |angle|
      center.endpoint angle, radius
    end

    from_points [points], center.srid
  end

  def side_count
    rings.sum(&:side_count)
  end

  def points
    rings.collect(&:points).flatten
  end

  def perimeter
    rings.sum(&:spherical_distance)
  end
  
  def centroid
    if rgeo_polygon = to_rgeo
      rgeo_polygon.centroid.to_georuby
    end
  end

  def self.union(georuby_polygons)
    return nil if georuby_polygons.empty?             

    rgeo_polygons = georuby_polygons.collect(&:to_rgeo)      
    rgeo_polygon_union = rgeo_polygons.first    
     
    rgeo_polygons[1..(rgeo_polygons.size - 1)].each do |rgeo_polygon|
       rgeo_polygon_union = rgeo_polygon_union.union(rgeo_polygon)
    end
    
    rgeo_polygon_union.to_georuby
  end

  def self.intersection(georuby_polygons)
    if !georuby_polygons.empty?
      polygon_intersection = georuby_polygons.first.to_rgeo
      georuby_polygons.shift
    end
    
    georuby_polygons.each do |polygon|
      polygon_intersection = polygon_intersection.intersection(polygon.to_rgeo)
    end

    polygon_intersection.to_georuby
  end

  def difference(georuby_polygon)
    polygon_difference = self.to_rgeo.difference(georuby_polygon.to_rgeo)
    polygon_difference.to_georuby
  end

  def to_rgeo
    outer_ring = rings.first.to_rgeo
    rings.size > 1 ? inner_rings = rings[1..(rings.size - 1)].collect(&:to_rgeo) : inner_rings = nil
    rgeo_factory.polygon(outer_ring, inner_rings)
  end  

  def change(options)
    self.class.from_linear_rings(options[:rings] || rings, 
                                 options[:srid] || srid,
                                 options[:with_z] || with_z, 
                                 options[:with_m] || with_m)
    # or instead of || requires parenthesis
  end

  def project_to(target_srid)
    return self if srid == target_srid
    change :rings => rings.map { |ring| ring.project_to(target_srid) }, :srid => target_srid
  end

end
