# spinel: int64 -- assumes a 64-bit Integer (wide Strings parse to Bignums)
def check(text)
  a = Integer(text)
  b = Integer(text, exception: false)
  p [a, b, a.class, b.class]
end
['1180591620717411303424', '-1180591620717411303424',
 '1234567890123456789012345678901234567890', '42', '-7'].each { |s| check(s) }
# A boxed String needs the same arbitrary-width result.
value = ['1180591620717411303424', 7][0]
p Integer(value)
p Integer(value, exception: false)
# Explicit bases retain the full String result as well.
p Integer('100000000000000000000', 16)
p Integer('100000000000000000000', 16, exception: false)
# Whole-String validation remains strict even after overflow is detected.
begin
  p Integer('1180591620717411303424x')
rescue => e
  p [e.class, e.message]
end
p Integer('1180591620717411303424x', exception: false)
