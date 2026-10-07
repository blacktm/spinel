# spinel: int64 -- assumes a 64-bit Integer (Integer(1e30) and 2.0**100 are Bignums)
def check(value)
  a = Integer(value)
  b = Integer(value, exception: false)
  p [a, b, a.class, b.class]
end
[1e30, -1e30, 1e18, 9.2e18, 2.0**63, 2.0**100,
 -(2.0**100), Float::MAX, -Float::MAX, 3.9, -3.9, 0.0].each { |v| check(v) }
# Nonfinite Floats retain the existing strict/lenient distinction.
[Float::INFINITY, -Float::INFINITY, Float::NAN].each do |value|
  begin
    p Integer(value)
  rescue => error
    p [error.class, error.message]
  end
  p Integer(value, exception: false)
end
# An explicit base still requires a String.
begin
  p Integer(1e30, 10)
rescue => error
  p [error.class, error.message]
end
p Integer(1e30, 10, exception: false)
