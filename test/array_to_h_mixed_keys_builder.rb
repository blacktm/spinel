# Every row contributes to the hash layout, including rows after a builder.
u = +"v"
u << "w"
p [["k", u], [1, "z"]].to_h
p [[1, "z"], ["k", u]].to_h
p [[:key, u], [1, "z"], ["k", 9]].to_h
p [[1, 2], ["k", u]].to_h
# A Symbol or Integer first key does not decide a later key's kind.
p [[:a, 1], ["b", 2]].to_h
p [[1, "a"], [2.5, "b"]].to_h
p [[1, 2], ["k", 3]].to_h
# Values of different kinds also need boxed slots.
p [["a", 1], ["b", "z"]].to_h
p [[1, 2], [3, "z"]].to_h
# Homogeneous pairs retain their specialized representation.
p [["a", "x"], ["b", "y"]].to_h
p [[1, 2], [3, 4]].to_h
GC.start
p u
