# == and eql? on a MatchData read out of a container compare its fields,
# as on a typed MatchData: same string, pattern and match are equal.
m1 = "abc".match(/b/)
m2 = "abc".match(/b/)
x = [m1, 0][0]
y = [m2, 0][0]
p [x == m2, x.eql?(m2), m2 == x, x == y]
p [x == "abc".match(/c/), x == "abd".match(/b/), x == "abc".match(/(b)/)]
p [x == nil, x == "b", x != m2]
p [[x, y].uniq.size, [x].include?(m2), [m2].index(x)]
