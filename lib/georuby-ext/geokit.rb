module GeoKit
  class LatLng

    def valid?
      self.lat and self.lng
    end

    def wgs84_to_google
      self.class.from_pro4j Proj4::Projection.wgs84.transform Proj4::Projection.google, self.proj4_point(Math::PI / 180)
    end

    def google_to_wgs84
      self.class.from_pro4j Proj4::Projection.google.transform(Proj4::Projection.wgs84, self.proj4_point), 180 / Math::PI  
    end

    def proj4_point(ratio = 1)
      Proj4::Point.new(lng * ratio, lat * ratio)
    end

    def self.from_pro4j(point, ratio = 1)
      new point.lat * ratio, point.lon * ratio
    end

  end
end
