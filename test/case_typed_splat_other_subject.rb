# A case statement's `when *ints` over an Integer Array tests a subject of
# another type by value, as CRuby does, where the C build failed.
ints = [1, 2, 3]
x = [2, 3]
case x
when *ints then p :hit
else p :miss
end
case [2, "s"][0]
when *ints then p :boxed_hit
else p :boxed_miss
end
strs = ["a", "b"]
case 5
when *strs then p :str_hit
else p :str_miss
end
case 2
when *ints then p :int_hit
end
