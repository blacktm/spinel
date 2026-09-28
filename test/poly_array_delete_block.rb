# delete(v) { } on a mixed Array runs the whole block on a miss, its
# parameter bound to the argument, and answers the block's value.
a = [1, "x", 2]
r = a.delete(9) { |v| puts "missing #{v}"; :none }
p r
p a
b = [1, "x", 2]
p b.delete("x") { puts "not run"; :none }
p b
n = 0
c = [1, "y"]
p c.delete("z") { |w| n += 1; w * 2 }
p n
