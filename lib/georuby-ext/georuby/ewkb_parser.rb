class GeoRuby::SimpleFeatures::EWKBParser

  private

  def parse_linear_ring_with_close_support
    parse_linear_ring_without_close_support 
    @factory.geometry.close!
  end
  alias_method_chain :parse_linear_ring, :close_support

end
