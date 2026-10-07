# spinel: int64 -- assumes a 64-bit Integer (Integer(1e30) and 2.0**100 are Bignums)
class Convert
  def strict(value)
    self.Integer(value)
  end
  def lenient(value)
    self.Integer(value, exception: false)
  end
end
c = Convert.new
[1e30, -1e30, 1e18, 9.2e18, 3.9, -3.9].each do |value|
  p [c.strict(value), c.lenient(value)]
end
p Integer(1e30)
p Integer(-1e30)
p Integer(1e30, exception: false)
p Integer(-1e30, exception: false)
