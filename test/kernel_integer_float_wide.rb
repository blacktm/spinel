def t(l); r = yield; puts "#{l} => #{r.inspect}"; rescue => e; puts "#{l} => #{e.class}: #{e.message}"; end
t("1e30")   { Integer(1e30) }
t("-1e30")  { Integer(-1e30) }
t("1e18")   { Integer(1e18) }
t("9.2e18") { Integer(9.2e18) }
t("1e30ef") { Integer(1e30, exception: false) }

# Both typed and boxed Float arguments, inside and outside machine bounds.
def strict(value)
  Integer(value)
end
def lenient(value)
  Integer(value, exception: false)
end

[1e30, -1e30, 1e18, 9.2e18, 2.0**63, 2.0**100,
 -(2.0**100), 3.9, -3.9, 0.0, -0.0, Float::MAX, -Float::MAX, "mixed"].each do |value|
  next if value == "mixed"
  p [strict(value), lenient(value), strict(value).class]
end
# Explicit typed function parameters are distinct from the mixed Array path.
def typed_strict(value)
  Integer(value)
end
def typed_lenient(value)
  Integer(value, exception: false)
end
p typed_strict(1e30)
p typed_strict(-1e30)
p typed_lenient(1e30)
p typed_lenient(-1e30)
# Nonfinite failure semantics stay distinct in the two forms.
[Float::INFINITY, -Float::INFINITY, Float::NAN, "mixed"].each do |value|
  next if value == "mixed"
  begin
    strict(value)
  rescue FloatDomainError => e
    p [e.class, e.message]
  end
  p lenient(value)
end
# A Float still does not admit an explicit base.
begin
  Integer(1e30, 10)
rescue ArgumentError => e
  p [e.class, e.message]
end
p Integer(1e30, 10, exception: false)

# Kernel conversion through an explicit object receiver uses the same result.
class Convert
  def strict(value)
    self.Integer(value)
  end
  def lenient(value)
    self.Integer(value, exception: false)
  end
end
c = Convert.new
p c.strict(1e30)
p c.strict(-1e30)
p c.lenient(1e30)
p c.lenient(-1e30)
# Mixed calls retain existing small values, strings and invalid-value errors.
[1e30, 3.9, 7, "42", nil, true, :x].each do |value|
  begin
    p c.strict(value)
  rescue => e
    p [e.class, e.message]
  end
  p c.lenient(value)
end
# An `||` keeps a plain Integer unless an operand may be a Float.
s = [nil, "8"][0]
p Integer(s || 7)
f = [nil, 1.5][0]
p Integer(f || 1e30)
