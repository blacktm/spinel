# A parenthesized `case/in` pattern (`in (-5..-1)`) is the pattern inside
# the parentheses, for a boxed subject and a typed one, at the top of an
# `in` and through an alternation or a capture: it tests the subject, binds
# its captures and names itself in a NoMatchingPatternError. A pinned value
# matches by its ===, as in a `when`; a boxed subject against a Range
# pattern by the Range's ===.
def pv(x) = x
pv(1); pv("s"); pv(1.5); pv(nil); pv(:a)

def row(v)
  [(case v; in (-5..-1) then 1; else 0; end),
   (case v; in (1..3) then 1; else 0; end),
   (case v; in (1...) then 1; else 0; end),
   (case v; in (..0) then 1; else 0; end),
   (case v; in ((2..9)) then 1; else 0; end),
   (case v; in (1) then 1; else 0; end),
   (case v; in (Integer) then 1; else 0; end),
   (case v; in (1 | 5) then 1; else 0; end),
   (case v; in (nil) then 1; else 0; end)].join(",")
end
[5, -3, 1, 0, "s", nil, :a].each { |x| puts row(pv(x)) }

puts(case 5; in (-5..-1) then 1; else 0; end)
puts(case -3; in (-5..-1) then 1; else 0; end)
puts(case 5; in (1) then 1; else 0; end)
puts(case 5.5; in (5..6) then 1; else 0; end)
puts(case pv(5); in (-5..-1) | (4..6) then 1; else 0; end)

# captures inside the parentheses bind
p(case 5; in (Integer => n) then n; else 0; end)
p(case 5; in ((1..9) | String) => n then n; else 0; end)
p(case 7; in (Integer => n) if n > 6 then n; else 0; end)
p(case pv("s"); in (Integer => n) then n; else 0; end)
p(case 5; in (x) then x; else 0; end)
"x" => (String => s)
p s
p(("y" in (String => t)), t)

# a parenthesized Find pattern at the top
p(case [1, 5, 3]; in ([*, 2..2, *]) then 1; else 0; end)
p(case [1, 5, 3]; in ([*, 5..5, *]) then 1; else 0; end)

# the NoMatchingPatternError message names the pattern inside
begin
  5 => (1..3)
rescue NoMatchingPatternError => e
  p e.message
end

# a pinned Range or class, in parentheses or not, matches by its ===
r = 2..4
k = String
[3, 5, pv(3), pv("q")].each do |v|
  p [(case v; in (^r) then 1; else 0; end), (case v; in ^r then 1; else 0; end),
     (case v; in ^k then 1; else 0; end), (case v; in [*] | ^r then 1; else 0; end)]
end
p(case 2.0; in ^r then 1; else 0; end)
f = ->(v) { v > 1 }
br = pv(2..4)
p [(case 2; in ^f then 1; else 0; end), (case 0; in (^f) then 1; else 0; end),
   (case 3; in ^br then 1; else 0; end), (case 9; in (^br) then 1; else 0; end)]

# a boxed subject the Integer compare cannot decide takes the Range's ===
def rr(v) = [(case v; in ("a".."m") then 1; else 0; end), (case v; in (1..3) then 1; else 0; end),
             (case v; in (1.5..2.5) then 1; else 0; end), (case v; in "a".."m" then 1; else 0; end)].join(",")
[1, 2.0, 3.5, "b", "z", nil, :a].each { |x| puts rr(pv(x)) }

# ...a Rational, a Bignum or a Float subject against an Integer Range, and
# any subject against a Float-bounded one
def rq(v) = [(case v; in 1..3 then 1; else 0; end), (case v; in 1.. then 1; else 0; end),
             (case v; in ..3 then 1; else 0; end), (case v; in 1.5..2.5 then 1; else 0; end)].join
[2r, 5r/2, 2**68, -(2**68), 2.0, 7].each { |x| puts rq(pv(x)) }

# a pinned endless or beginless Range, String Range, Module, proc, Set or
# object with its own ===
require "set"
class Ev; def ===(o) = o.is_a?(Integer) && o.even?; end
er = (3..); bl = (..3); sr = "a".."m"; md = Comparable; pr = proc { |v| v == 2 }
st = Set[1, 2]; ev = Ev.new
[2, 3, 9, pv(2)].each do |v|
  puts [(case v; in ^er then 1; else 0; end), (case v; in ^bl then 1; else 0; end), (case v; in ^md then 1; else 0; end),
        (case v; in ^pr then 1; else 0; end), (case v; in ^st then 1; else 0; end), (case v; in ^ev then 1; else 0; end)].join
end
["b", "z"].each { |v| puts [(case v; in ^sr then 1; else 0; end), (case v; in ^md then 1; else 0; end)].join }
