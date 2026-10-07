b = ["abc", 1]
p b.grep("a".."z")
p b.any?(/b/)
s = +"ab"
s << "c"
a = [s, 1]
p a.grep("a".."z")

values = ["a", "abc", "z", "zz", 1, nil, s]
p values.grep("a".."z")
p values.grep("a"..."z")
p values.grep_v("a".."z")
p values.any?("a".."z")
p values.grep("a".."z") { |v| v.upcase }
