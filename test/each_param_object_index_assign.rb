# A block walking an array that holds one user class (each, reverse_each,
# each_entry, each_with_index, map, collect) stores through the element's
# own []= with `r[k] = v`. On 4ea42f77 the block parameter is typed as a
# Hash and this program segfaults before printing anything.
class Headers
  def initialize; @h = {}; end
  def []=(k, v); @h[k.downcase] = [v.to_s]; end
  def [](k); a = @h[k.downcase]; a ? a.join(", ") : nil; end
end

a = [Headers.new, Headers.new]
a.each { |r| r["X-A"] = "1" }
a.reverse_each { |r| r["X-B"] = "2" }
a.each_entry { |r| r["X-C"] = "3" }
a.each_with_index { |r, i| r["X-D"] = i.to_s }
a.map { |r| r["X-E"] = "5"; 0 }
a.collect { |r| r["X-F"] = "6"; 0 }
p a[0]["x-a"]
p a.map { |r| [r["x-b"], r["x-c"], r["x-d"], r["x-e"], r["x-f"]] }
