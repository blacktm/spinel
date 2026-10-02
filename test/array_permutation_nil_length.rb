# Array#permutation takes a nil length as an omitted one: every element.
p [1, 2].permutation(nil).to_a
p ["a", "b"].permutation(nil).to_a
p [1.5, 2.5].permutation(nil).to_a
p [1, "a"].permutation(nil).to_a
p [].permutation(nil).to_a

# The Enumerator keeps the nil in its inspect, and its size refuses it, as
# CRuby's does.
e = [1, 2, 3].permutation(nil)
p e
p e.first, e.to_a.length
begin
  p e.size
rescue TypeError => err
  p [err.class, err.message]
end

# With a block
rows = []
[1, 2].permutation(nil) { |row| rows << row }
p rows
rows = []
[1.5, 2.5].permutation(nil) { |row| rows << row }
p rows
rows = []
[1, "a"].permutation(nil) { |row| rows << row }
p rows

# A count evaluated once, nil or not, read from a box or a missed index
def arg_once(value)
  print "N"
  value
end
p [1, 2].permutation(arg_once(nil)).to_a
p [1, 2].permutation(arg_once(1)).to_a
p [1, "a"].permutation(arg_once(nil)).to_a
begin
  p [1, 2].permutation(arg_once("x")).to_a
rescue TypeError => err
  p [err.class, err.message]
end
boxed = [nil, 1][0]
p [1, 2, 3].permutation(boxed).to_a.length
missing = "x".index("y")
p [1, 2].permutation(missing).to_a
counts = [1, "x"]
counts.pop
p [1, 2].permutation(*counts).to_a

# The other combinators still require an Integer
begin
  p [1, 2].combination(nil).to_a
rescue TypeError => err
  p [err.class, err.message]
end
begin
  p [1, 2].repeated_permutation(nil).to_a
rescue TypeError => err
  p [err.class, err.message]
end
