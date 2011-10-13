class GeoRuby::SimpleFeatures::Polygon

  def self.circle(center, radius, sides_number = 24)
    points = sides_number.times.map do |side|
      2 * 180 / sides_number * side
    end.map do |angle|
      center.endpoint angle, radius
    end

    # Close the circle
    points << points.first

    from_points [points], center.srid
  end

  def side_count
    # Reduce by one because polygon is closed
    (rings.collect(&:size).sum) - 1
  end

  def points
    rings.collect(&:points).flatten
  end

  def centroid
    if rgeo_polygon = to_rgeo
      rgeo_polygon.centroid.to_georuby
    end
  end

  def self.union(georuby_polygons)
    factory = RGeo::Geos::Factory.create
    if !georuby_polygons.empty?
      polygon_union = georuby_polygons.first.to_rgeo
      georuby_polygons.shift
    end
     
    georuby_polygons.each do |polygon|
       polygon_union = polygon_union.union(polygon.to_rgeo)
    end
    
    polygon_union.to_georuby
   end

  def self.intersection(georuby_polygons)
    factory = RGeo::Geos::Factory.create
    if !georuby_polygons.empty?
      polygon_intersection = georuby_polygons.first.to_rgeo
      georuby_polygons.shift
    end
    
    georuby_polygons.each do |polygon|
      polygon_intersection = polygon_intersection.intersection(polygon.to_rgeo)
    end

    polygon_intersection.to_georuby
  end

  def to_wgs84
    self.class.from_points([self.points.collect(&:to_wgs84)], 4326)
  end

  def to_google
    self.class.from_points([self.points.collect(&:to_google)], 900913)
  end

  def to_rgeo
    RGeo::Geos::factory(:srid => srid).polygon(rings.collect(&:to_rgeo).first)
  end  

end
