# `x[k] = v` on a boxed receiver, in a program where user classes define
# their own []=: the user object's []= runs, and a Hash or an Array
# receiver still stores the value itself. On 4ea42f77 lines 1, 2, 6 and 7
# print nil (the user []= never ran); the other four already print what
# the .expected holds.
class Headers
  def initialize; @h = {}; end
  def []=(k, v); @h[k.downcase] = v.to_s; end
  def [](k); @h[k.downcase]; end
end

class Slots
  def initialize; @a = []; end
  def []=(i, v); @a[i] = v * 2; end
  def [](i); @a[i]; end
end

def pick(i) = [Headers.new, Slots.new, {"a" => "b"}, [1, 2, 3], {x: 1}][i]

xs = (0..4).map { |i| pick(i) }
xs[0]["X-A"] = "7"
xs[1][1] = 4
xs[2]["k"] = "v"
xs[3][1] = 9
xs[4][:y] = 2
p xs[0]["x-a"]
p xs[1][1]
p xs[2]
p xs[3]
p xs[4]

r = xs[0]
v = (r["Y"] = "8")
p [v, r["y"]]

[Headers.new, {"z" => "0"}].each { |h| h["Z"] = "9"; p h["Z"] }
