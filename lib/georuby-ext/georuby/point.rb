require 'active_support/core_ext/object/blank'

class GeoRuby::SimpleFeatures::Point

  # Earth radius in kms
  #
  # GeoRuby Point#spherical_distance uses 6370997.0 m
  # Geokit::LatLng uses 6376.77271 km
  # ...
  @@earth_radius = 6370997.0
  def self.earth_radius
    @@earth_radius 
  end
  def earth_radius
    self.class.earth_radius
  end

  # Length of a latitude degree in meters
  @@latitude_degree_distance = @@earth_radius * 2 * Math::PI / 360
  def self.latitude_degree_distance
    @@latitude_degree_distance 
  end
  def latitude_degree_distance
    self.class.latitude_degree_distance
  end

  def change(options)
    # TODO support z
    self.class.from_x_y(options[:x] || x, 
                        options[:y] || y, 
                        options[:srid] || srid)
    # or instead of || requires parenthesis
  end

  def ==(other)
    other and 
      other.respond_to?(:lat) and other.respond_to?(:lng) and
      spherical_distance(other) < 10e-3
  end

  def spherical_distance_with_srid_support(other)
    to_wgs84.spherical_distance_without_srid_support(other.to_wgs84)
  end
  alias_method_chain :spherical_distance, :srid_support

  def endpoint(heading, distance, options={})
    Endpointer.new(self, heading, distance, options).arrival
  end

  class Endpointer

    attr_accessor :origin, :heading, :distance, :unit

    def initialize(origin, heading, distance, options = {})
      @origin, @heading, @distance = origin, heading.deg2rad, distance
    end

    def radius
      GeoRuby::SimpleFeatures::Point.earth_radius
    end

    def distance_per_radius
      @distance_per_radius ||= distance / radius
    end

    def cos_distance_per_radius
      @cos_distance_per_radius ||= Math.cos(distance_per_radius)
    end

    def sin_distance_per_radius
      @sin_distance_per_radius ||= Math.sin(distance_per_radius)
    end

    def latitude
      @latitude ||= origin.lat.deg2rad
    end

    def cos_latitude
      @cos_latitude ||= Math.cos(latitude)
    end

    def sin_latitude
      @sin_latitude ||= Math.sin(latitude)
    end

    def longitude
      @longitude ||= origin.lng.deg2rad
    end

    def arrival_latitude
      Math.asin(sin_latitude * cos_distance_per_radius +
                cos_latitude * sin_distance_per_radius * Math.cos(heading))
    end

    def arrival_longitude
      longitude + Math.atan2(Math.sin(heading) * sin_distance_per_radius * cos_latitude,
                             cos_distance_per_radius - sin_latitude * Math.sin(arrival_latitude))
    end

    def arrival
      origin.change :x => arrival_longitude.rad2deg, :y => arrival_latitude.rad2deg    end

  end

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

  def projection
    Proj4::Projection.for_srid srid
  end
  
  def project_to(target_srid)
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

  def metric_delta(other)
    longitude_degree_distance =
      (latitude_degree_distance * Math.cos(lat.deg2rad)).abs
    [ latitude_degree_distance * (other.lat - lat),
      longitude_degree_distance * (other.lng - lng) ]
  end

end
