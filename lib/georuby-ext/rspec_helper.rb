RSpec::Matchers.define :be_same_polygon do |reference|
  match do |actual|
    reference = 
      case reference
      when Array
        GeoRuby::SimpleFeatures::Polygon.from_coordinates [reference]
      when String
        geometry reference
      else
        reference
      end

    [actual.points, reference.points].transpose.all? do |actual_point, reference_point|
      actual_point.euclidian_distance(reference_point) < 0.01
    end
  end
end

def geometry(text, srid = 4326)
  GeoRuby::SimpleFeatures::Geometry.from_ewkt "SRID=#{srid};#{text}"
end

def point(x=0.0, y=0.0, srid = 4326)
  GeoRuby::SimpleFeatures::Point.from_x_y(x,y,srid)
end

def points(text)
  text.split(",").collect { |definition| geometry "POINT(#{definition})" }
end

def line_string(*points)
  if points.one? and String === points.first
    geometry("LINESTRING(#{points})")
  else
    GeoRuby::SimpleFeatures::LineString.from_points(points)
  end
end

def linear_ring(*points)
  GeoRuby::SimpleFeatures::LinearRing.from_points(points)
end

def polygon(*points)
  GeoRuby::SimpleFeatures::Polygon.from_points([points])
end

def multi_polygon(*polygons)
  GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([polygons])
end

def rgeo_point(x = 0, y = 0, srid = 4326)
  RGeo::Geos.factory(:srid => srid).point(x, y)
end

def rgeometry(text, srid = 4326)
  RGeo::Geos.factory(:srid => srid).parse_wkt text
end

def rgeo_line_string(text, srid = 4326)
  rgeometry "LINESTRING(#{text})"
end
