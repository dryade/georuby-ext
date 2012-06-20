module GeoKit
  class LatLng

    def valid?
      self.lat and self.lng and
        self.lat >= -90 and self.lat <= 90 and
        self.lng >= -180 and self.lng <= 180
    end

    # DEPRECATED
    # Use Point geometry which supports srid

    def wgs84_to_google
      ActiveSupport::Deprecation.warn "use Point geometry which supports srid"
      self.class.from_pro4j Proj4::Projection.wgs84.transform Proj4::Projection.google, self.proj4_point(Math::PI / 180).x, self.proj4_point(Math::PI / 180).y
    end

    def google_to_wgs84
      ActiveSupport::Deprecation.warn "use Point geometry which supports srid"
      self.class.from_pro4j Proj4::Projection.google.transform(Proj4::Projection.wgs84, self.proj4_point.x, self.proj4_point.y), 180 / Math::PI 
    end

    def proj4_point(ratio = 1)
      Proj4::Point.new(lng * ratio, lat * ratio)
    end

    def self.from_pro4j(point, ratio = 1)
      new point.lat * ratio, point.lon * ratio
    end

  end
end
