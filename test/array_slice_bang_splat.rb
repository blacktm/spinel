idx = [5, 3]
ints = (1..10).map { |i| i * 10 }
p ints.slice!(*idx)
p ints
strs = (1..10).map { |i| "s#{i}" }
p strs.slice!(*idx)
p strs.length
polys = (1..10).map { |i| i.odd? ? i : "s#{i}" }
p polys.slice!(*idx)
p polys.length
one = [2]
p ints.slice!(*one)

# Runtime-length arguments use the same one/two-argument selection.
def remove_slice(array, indices)
  array.slice!(*indices)
end
array = [10, 20, 30, 40]
p remove_slice(array, [1, 2])
p array
p remove_slice(array, [0])
p array
# The argument Array remains an ordinary mutable object.
indices = [1, 2]
array = [10, 20, 30, 40]
p array.slice!(*indices)
indices.pop
p array.slice!(*indices)
p [array, indices]
# String#slice! takes the same splat.
s = +"hello world"
pair = [3, 4]
p s.slice!(*pair)
p s
t = +"hello"
range = [1..3]
p t.slice!(*range)
p t
