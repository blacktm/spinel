require "ostruct"
# o.member = v on an OpenStruct read out of a container sets the member, as
# on a typed OpenStruct, and the assignment's value is v.
o = OpenStruct.new(a: 1)
x = [o, 0][0]
x.a = 3
x.b = "s"
p [o.a, o.b]
v = (x.c = [1, 2])
p v
p x.c
p o.to_h
y = [OpenStruct.new, 0][0]
y.n = 1
y.n = y.n + 1
p y.n
p((begin; [nil, 0][0].z = 1; rescue NoMethodError => e; e.message; end))
