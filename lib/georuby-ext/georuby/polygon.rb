class GeoRuby::SimpleFeatures::Polygon

  def self.circle(center, radius, sides_number = 24)
    coordinates = (0...sides_number).collect do |side|
      2 * 180 / sides_number * side
    end.collect do |angle|
      point = GeoRuby::SimpleFeatures::Point.from_lat_lng(center.to_lat_lng.endpoint(angle, radius, {:units => :kms}))
      [point.x, point.y]
    end
    # Close the circle
    coordinates << coordinates.first
    from_coordinates [coordinates]
  end

  def inspect
    "#<#{self.class}:#{object_id} #{as_ewkt}>"
  end

  # def inspect
  #   "[" + rings.collect do |ring|
  #     "[" + ring.points.collect do |point|
  #       "[#{point.x},#{point.y}]"
  #     end.join(',') + "]"
  #   end.join(',') + "]"
  # end

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

  def to_rgeo
    # take only the first ring for the outer ring of RGeo::Feature::Polygon
    factory = RGeo::Geos::Factory.create #(:srid => srid)
    polygon = factory.polygon(self.rings.collect(&:to_rgeo).first)
  end  

end
