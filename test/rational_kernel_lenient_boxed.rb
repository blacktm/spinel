# exception:false suppresses failures; a valid Rational still converts.
q = [Rational(3, 2), "mixed"][0]
p Integer(q, exception: false)
p Float(q, exception: false)
[Rational(3, 2), Rational(-3, 2), Rational(0, 1), Rational(7, 1), "mixed"].each do |value|
  next if value == "mixed"
  integer = Integer(value, exception: false)
  float = Float(value, exception: false)
  p [integer, integer.class, float, float.class]
end
# Exact large quotients need a boxed Integer result rather than a word slot.
[ Rational(2**100, 3), Rational(-(2**100), 3), "mixed" ].each do |value|
  next if value == "mixed"
  p Integer(value, exception: false)
  p Float(value, exception: false)
end
p Integer(Rational(3, 2), exception: false)
p Float(Rational(3, 2), exception: false)
p Integer(Rational(-3, 2), exception: false)
p Float(Rational(-3, 2), exception: false)
p Integer(Rational(3, 2), 10, exception: false)
# Other invalid inputs continue to yield nil.
[nil, true, :x, "bad"].each do |value|
  p Integer(value, exception: false)
  p Float(value, exception: false)
end
# A boxed Bignum is answered whole, not dropped to nil.
big = [2**70, "mixed"][0]
p Integer(big, exception: false)
p Integer([-(2**70), "mixed"][0], exception: false)
