class GeoRuby::SimpleFeatures::Point

  def self.from_lat_lng(object, srid = GeoRuby::SimpleFeatures::DEFAULT_SRID)
    if object.respond_to?(:to_lat_lng)
      lat_lng = object.to_lat_lng
    else
      lat_lng = Geokit::LatLng.normalize object
    end 
    from_x_y lat_lng.lng, lat_lng.lat, srid
  end

  def eql?(other)
     [x,y,srid] == [other.x, other.y, other.srid]
  end

  def hash
    [x,y,srid].hash
  end

  def to_s
    "#{y},#{x}"
  end

  def self.centroid(points)
    case points.size
    when 0
      nil
    when 1
      points.first
    when 2
      return GeoRuby::SimpleFeatures::Point.from_x_y points.map(&:x).sum / 2, points.map(&:y).sum / 2, points.first.srid
    else
      points = [points.last, *points]
      GeoRuby::SimpleFeatures::Polygon.from_points([points]).centroid.tap do |centroid|
        centroid.srid = points.first.srid if centroid
      end
    end
  end

  def to_lat_lng
    Geokit::LatLng.new y, x
  end

  def to_s
    to_lat_lng.to_s
  end

  def to_wgs84
    self.class.from_lat_lng to_lat_lng.google_to_wgs84, 4326
  end

  def to_google
    self.class.from_lat_lng to_lat_lng.wgs84_to_google, 900913
  end

  def to_rgeo
    factory = RGeo::Geos::Factory.create
    factory.point(self.x, self.y)
  end  

  def to_openlayers
    OpenLayers::LonLat.new x, y
  end

  def self.bounds(points)
    return nil if points.blank?

    points.inject(points.first.envelope) do |envelope, point|
      envelope.extend!(point.envelope)
    end
  end

end
