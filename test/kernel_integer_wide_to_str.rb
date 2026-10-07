# spinel: int64 -- assumes a 64-bit Integer (wide Strings parse to Bignums)
$calls = 0
class Text
  def initialize(text)
    @text = text
  end
  def to_str
    $calls += 1
    GC.start
    @text
  end
end
class Convert
  def strict(value)
    self.Integer(value)
  end
  def lenient(value)
    self.Integer(value, exception: false)
  end
end
c = Convert.new
['1180591620717411303424', '-1180591620717411303424', '42'].each do |text|
  value = Text.new(text)
  $calls = 0
  p Integer(value)
  p Integer(value, exception: false)
  p c.strict(value)
  p c.lenient(value)
  p $calls
end
# The conversion result can outlive its temporary source object.
part = Integer(Text.new('123456789012345678901234567890'))
GC.start
p part
