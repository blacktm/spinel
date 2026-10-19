# spinel: int64 -- the Integers at and past +-2**62, where CRuby holds a Bignum
# A boxed Integer, Symbol, nil, true or false answers the object_id its
# typed form does, so a boxed copy compares equal to it
def pick(i)
  i == 0 ? 1234 : :a
end

x = [1234, :a][0]
p x.object_id == 1234.object_id
p x.object_id
p [-5, :a][0].object_id == -5.object_id
p [0, :a][0].object_id == 0.object_id
p pick(0).object_id == 1234.object_id
p [:s, 1][0].object_id == :s.object_id
p pick(1).object_id == :a.object_id
syms = [:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, 1]
ids = syms.map(&:object_id)
p ids.include?(false.object_id) || ids.include?(nil.object_id) || ids.include?(true.object_id)
p :a.object_id == false.object_id
p [nil, 1][0].object_id == nil.object_id
p [nil, 1][0].object_id
p [true, 1][0].object_id == true.object_id
p [true, 1][0].object_id
p [false, 1][0].object_id == false.object_id
p [false, 1][0].object_id

# past +-2**62 CRuby holds a Bignum: its own id, not 2n+1 overflowed
a = 4611686018427387904
b = -4611686018427387904
p a.object_id == b.object_id
p [a, :x][0].object_id == [b, :x][0].object_id
p [a, :x][0].object_id == a.object_id
m = 4611686018427387903
p m.object_id
p [m, :x][0].object_id
p [b, :x][0].object_id
lo = -9223372036854775807 - 1
p [lo, :x][0].object_id == false.object_id
p lo.object_id == false.object_id

# a heap value keeps its own identity
s = +"abc"
p [s, 1][0].object_id == s.object_id
p [+"abc", 1][0].object_id == s.object_id
arr = [1]
p [arr, 1][0].object_id == arr.object_id
p [[1], 1][0].object_id == arr.object_id
p x.__id__ == 1234.__id__
