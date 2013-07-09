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
  if String === x
    geometry("POINT(#{x})")
  else
    GeoRuby::SimpleFeatures::Point.from_x_y x, y, srid
  end
end

def points(text)
  text.split(",").collect { |definition| point definition }
end

def line_string(*points)
  if points.one? and String === points.first
    geometry("LINESTRING(#{points.join(",")})")
  else
    GeoRuby::SimpleFeatures::LineString.from_points(points, points.first.srid)
  end
end

def multi_line_string(*lines)
  if lines.one? and String === lines.first
    geometry("MULTILINESTRING(#{lines.join(",")})")
  else
    GeoRuby::SimpleFeatures::MultiLineString.from_line_strings lines, lines.first.srid
  end
end

def linear_ring(*points)
  GeoRuby::SimpleFeatures::LinearRing.from_points(points, points.first.srid)
end

def envelope(lower_corner, upper_corner)
  lower_corner = point(lower_corner) if String === lower_corner
  upper_corner = point(upper_corner) if String === upper_corner

  GeoRuby::SimpleFeatures::Envelope.from_points([lower_corner, upper_corner], lower_corner.srid)
end

def polygon(*points)
  if points.one? and String === points.first
    geometry("POLYGON(#{points.join(",")})")
  else
    GeoRuby::SimpleFeatures::Polygon.from_points([points], points.first.srid)
  end
end

def multi_polygon(*polygons)
  GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([polygons], polygons.first.srid)
end

def rgeo_factory
  @rgeo_factory ||= RGeo::Geos.factory(:srid => 4326, :native_interface => :ffi, :wkt_parser => {:support_ewkt => true})
end

def rgeo_point(x = 0, y = 0, srid = 4326)
  rgeo_factory.point(x, y)
end

def rgeo_multi_polygon(polygons, srid = 4326)
  rgeo_factory.multi_polygon(polygons)
end

def rgeo_multi_line_string(multi_line_string, srid = 4326)
  if lines.one? and String === lines.first
    geometry("MULTILINESTRING(#{lines})")
  else
    Rgeo::Geos::MultiLineString.from_line_strings lines, lines.first.srid
  end
end

def rgeometry(text, srid = 4326)
  rgeo_factory.parse_wkt text
end

def rgeo_line_string(text, srid = 4326)
  rgeometry "LINESTRING(#{text})"
end
