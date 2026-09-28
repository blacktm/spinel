# `return x if x.is_a?(M)` with a module M answers x itself: the value keeps
# its own class, so its methods are still reachable.
module Named
  def label = "named:#{tag}"
end
class Item
  include Named
  def initialize(t); @t = t; end
  def tag = @t
end
class Base; end
class Sub < Base
  def initialize(t); @t = t; end
  def tag = @t
end
def ret(x)
  return x if x.is_a?(Named)
  nil
end
r = ret(Item.new("b"))
puts r.tag
puts r.label
p ret(5)
def ret_base(x)
  return x if x.is_a?(Base)
  nil
end
puts ret_base(Sub.new("c")).tag
