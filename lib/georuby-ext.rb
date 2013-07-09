require 'ffi-proj4'
require 'geo_ruby'
require 'geokit'
require 'rgeo'

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/deprecation'

require 'georuby-ext/core_ext'

require 'georuby-ext/rgeo/feature/geometry'
require 'georuby-ext/rgeo/feature/geometry_collection'
require 'georuby-ext/rgeo/geos/ffi_feature_methods'

require 'georuby-ext/geokit'
require 'georuby-ext/proj4'

require 'georuby-ext/georuby/rtree'
require 'georuby-ext/georuby/srid'
require 'georuby-ext/georuby/geometry'
require 'georuby-ext/georuby/point'
require 'georuby-ext/georuby/line_string'
require 'georuby-ext/georuby/linear_ring'
require 'georuby-ext/georuby/polygon'
require 'georuby-ext/georuby/multi_polygon'
require 'georuby-ext/georuby/envelope'
require 'georuby-ext/georuby/locators'

require 'georuby-ext/georuby/ewkt_parser'
