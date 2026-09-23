# `obj[k] = v` on a user object is an assignment expression: its value is
# v as written, whatever the class's []= returns, as for `obj.x = v`. On
# 4ea42f77 lines 1-5 and 8 print the []= return value instead (a chained
# store also puts it into the second key); lines 6 and 7 already print what
# the .expected holds.
class H
  def initialize; @h = {}; end
  def []=(k, v); @h[k] = v; [v]; end
  def [](k); @h[k]; end
end
h = H.new
x = (h["k"] = "5")
p x
p [1, 2].map { |i| h["k#{i}"] = i.to_s }
p(h["n"] = 7)
y = h["z"] = h["w"] = "chain"
p y, h["z"], h["w"]
h["s"] = "stmt"
p h["s"]
def set_it(o) = (o["m"] = :sym)
p set_it(h)
