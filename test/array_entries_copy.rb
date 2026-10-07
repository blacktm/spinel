a = [1, 2]
e = a.entries
e << 3
p a
s = ["x"]
t = s.entries
t << "y"
p s
f = [1.5]
g = f.entries
g << 2.5
p f

p [e.equal?(a), t.equal?(s), g.equal?(f)]
poly = [1, "x"]
copy = poly.entries
copy << :tail
p [poly, copy, copy.equal?(poly)]
shifted = [9, 1, 2]
shifted.shift
copy = shifted.entries
copy << 3
p [shifted, copy]
frozen_array = [1, 2].freeze
copy = frozen_array.entries
copy << 3
p [copy.frozen?, frozen_array, copy]
