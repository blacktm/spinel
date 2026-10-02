class Convert
  def integer(value)
    self.Integer(value, exception: false)
  end
  def float(value)
    self.Float(value, exception: false)
  end
end
class NumericInput
  def to_int
    7
  end
  def to_f
    2.5
  end
end
c = Convert.new
[Rational(3, 2), Rational(-3, 2), Rational(2**100, 3), NumericInput.new, "mixed"].each do |value|
  next if value == "mixed"
  p c.integer(value)
  p c.float(value)
end
# A temporary Rational is rooted while its exact quotient allocates.
def rational
  GC.start
  [Rational(2**100, 3), "mixed"][0]
end
p c.integer(rational)
p c.float(rational)
