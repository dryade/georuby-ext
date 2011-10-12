require 'active_support/core_ext/object/blank'

class GeoRuby::SimpleFeatures::Point

  def ==(other)
    other and distance(other) < 10e-3
  end

  def euclidian_distance_with_srid_support(other)
    to_wgs84.euclidian_distance_without_srid_support(other.to_wgs84)
  end
  alias_method_chain :euclidian_distance, :srid_support

  def spherical_distance_with_srid_support(other)
    to_wgs84.spherical_distance_without_srid_support(other.to_wgs84)
  end
  alias_method_chain :spherical_distance, :srid_support

  # TODO use euclidian_distance when other is very close
  alias_method :distance, :spherical_distance

  def eql?(other)
     [x,y,z,srid] == [other.x, other.y, other.z, other.srid]
  end

  def hash
    [x,y,z,srid].hash
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
      from_x_y points.sum(&:x) / 2, points.sum(&:y) / 2, srid!(points)
    else
      points = [points.last, *points] # polygon must be closed for rgeo
      GeoRuby::SimpleFeatures::Polygon.from_points([points], srid!(points)).centroid
    end
  end

  def self.from_lat_lng(object, srid = 4326)
    ActiveSupport::Deprecation.warn "Don't use Geokit::LatLng to represent no wgs84 point" unless srid == 4326
    
    if object.respond_to?(:to_lat_lng)
      lat_lng = object.to_lat_lng
    else
      lat_lng = Geokit::LatLng.normalize object
    end 
    from_x_y lat_lng.lng, lat_lng.lat, srid
  end

  def to_lat_lng
    Geokit::LatLng.new y, x
  end

  def to_wgs84
    project 4326
  end

  def to_google
    project 900913
  end

  def projection
    Proj4::Projection.for_srid srid
  end
  
  def project(target_srid)
    return self if srid == target_srid

    self.class.from_pro4j projection.transform(Proj4::Projection.for_srid(target_srid), to_proj4), target_srid
  end

  def to_proj4(ratio = nil)
    # Proj4 use radian instead of degres
    ratio ||= (wgs84? ? Proj4::DEG_TO_RAD : 1.0)
    Proj4::Point.new x * ratio, y * ratio
  end

  def self.from_pro4j(point, srid, ratio = nil)
    ratio ||= (srid == 4326 ? Proj4::RAD_TO_DEG : 1.0)
    from_x_y point.x * ratio, point.y * ratio, srid
  end

  def to_rgeo
    RGeo::Geos.factory(:srid => srid).point(x, y)
  end

  def to_openlayers
    OpenLayers::LonLat.new x, y
  end

  # Fixes original bounding_box which creates points without srid
  def bounding_box
    Array.new(with_z ? 3 : 2) { dup }
  end

  def self.bounds(points)
    return nil if points.blank?

    points.inject(points.first.envelope) do |envelope, point|
      envelope.extend!(point.envelope)
    end
  end

  def self.srid!(points)
    points.first.srid.tap do |srid|
      raise "SRIDs are not uniq in #{points.inspect}" if points.any? { |point| point.srid != srid }
    end unless points.blank?
  end

end
