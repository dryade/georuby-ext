class GeoRuby::SimpleFeatures::Geometry

  def inspect
    "#<#{self.class}:#{object_id} \"#{to_ewkt}>\""
  end
  
  alias_method :to_ewkt, :as_ewkt

  def wgs84?
    srid == 4326
  end

  def to_wgs84
    project_to 4326
  end

  def to_google
    project_to 900913
  end

  def self.srid!(geometries)
    geometries.first.srid.tap do |srid|
      raise "SRIDs are not uniq in #{geometries.inspect}" if geometries.any? { |geometry| geometry.srid != srid }
    end unless geometries.blank?
  end

  def srid_instance
    @srid_instance ||= GeoRuby::SimpleFeatures::Srid.new(srid)
  end
  delegate :rgeo_factory, :to => :srid_instance

  alias_method :bounds, :envelope

end
