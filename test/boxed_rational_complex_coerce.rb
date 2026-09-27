# coerce on a Rational or a Complex read out of a container answers the
# pair CRuby answers for an Integer, a Float or an operand of the same
# kind, and raises TypeError for a value that is no number.
r = [Rational(7, 2), 0][0]
c = [Complex(2, 3), 0][0]
p r.coerce(2)
p r.coerce(Rational(1, 3))
p r.coerce(2.5)
p c.coerce(2)
p c.coerce(2.5)
p c.coerce(Complex(1, 1))
[r, c].each do |v|
  e = (v.coerce("x") rescue $!)
  p [e.class, e.message]
  e = (v.coerce(nil) rescue $!)
  p [e.class, e.message]
end
a, b = r.coerce(3)
p a + b
