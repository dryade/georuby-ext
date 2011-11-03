class GeoRuby::SimpleFeatures::Srid
  attr_accessor :srid 

  def initialize(srid)   
    @srid ||= srid
  end 

  @@instances = {}
  def self.new(srid)
    @@instances[srid] ||= super(srid)
  end
 
  def rgeo_factory
    @rgeo_factory ||= RGeo::Geos::factory(:srid => srid)
  end

end
