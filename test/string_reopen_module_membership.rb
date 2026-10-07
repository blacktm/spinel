module Shouty
  def shout = upcase + "!"
end
class String
  include Shouty
  def twice = self * 2
end
s = +"ab"
s << "c"
a = [s, 1, "pl"]
p a.grep(String)
p a.grep(Shouty)
p a.any?(Shouty)
p a.count { |v| String === v }
p a.count { |v| Shouty === v }
p a.count { |v| v.is_a?(Shouty) }
p a[0].twice
x = a[0]
p String === x, Shouty === x, x.is_a?(String)

p [x.is_a?(Comparable), x.is_a?(Object), x.kind_of?(Shouty), x.instance_of?(Shouty)]
p a.count { |v| v.kind_of?(Shouty) }
klass = x.class
p klass === x
