module RGeo
  module Feature
    module GeometryCollection      
      
      def to_georuby
        raise Error::UnsupportedOperation, "Method GeometryCollection#to_georuby not defined."
      end      
      
    end
  end
end
