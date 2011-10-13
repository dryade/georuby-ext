class Numeric

  def deg2rad
    to_f / 180.0 * Math::PI
  end

  def rad2deg
    to_f * 180.0 / Math::PI 
  end

end
