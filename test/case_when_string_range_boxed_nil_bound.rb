# spinel: gc-stress
# A String-subject `when` with a literal String range whose bound is a
# boxed value (a reader answering nil or a String) checks the range.
class Box
  def initialize(lo); @lo = lo; end
  def lo; @lo; end
end
b = Box.new(nil)
def s(x); x + ""; end
r = case s("zzz")
    when (b.lo.."m") then :closed
    else :no
    end
p [:str_range_nil_begin, r]
r = case s("b")
    when ("a"..b.lo) then :open
    else :no
    end
p [:str_range_nil_end, r]

sb = Box.new("c"); ib = Box.new(5)
p(case s("b") when ("a"...b.lo) then :y else :n end)
p(case s("b") when (b.lo.."c") then :y else :n end)
p(case s("d") when (b.lo.."c") then :y else :n end)
p(case s("b") when ("a"..sb.lo) then :y else :n end)
p(case s("c") when ("a"...sb.lo) then :y else :n end)
p(case s("d") when ("a"..sb.lo) then :y else :n end)
p(case "b" when ("a"..b.lo) then :y else :n end)
p(case s("b") when ("a"..b.lo), "q" then :y else :n end)
p(case s("q") when ("a"..sb.lo), "q" then :y else :n end)
begin
  p(case s("b") when ("a"..ib.lo) then :y else :n end)
rescue ArgumentError => e
  p [:argerr, e.message]
end
x = case s("b"); when ("a"..b.lo) then 1; end
p x

# a bound typed nil, or the literal nil, is an open bound too
def nl = nil
p(case s("b") when ("a"..nil) then :y else :n end)
p(case s("b") when ("a"..nl) then :y else :n end)
p(case s("b") when (nl.."c") then :y else :n end)
p(case s("d") when (nl.."c") then :y else :n end)
p(case s("b") when (nl..nl) then :y else :n end)
# two boxed nil bounds: a Range open at both ends covers everything
p(case s("b") when (b.lo..b.lo) then :y else :n end)

# the bounds run once each, in order, and only up to the arm that matches
$log = []
class Q
  def v; $log << :q; nil; end
end
q = Q.new
def lo; $log << :lo; "a" + ""; end
r = case s("b")
    when (q.v.."0"), (lo..b.lo), (lo..q.v) then :one
    end
p r, $log
$log = []
case s("0")
when (b.lo..q.v) then p :both
when (lo..q.v) then p :never
end
p $log

# a user object bound is compared by its own <=> in CRuby; this one is
# never covered for an exclusive end
class Cmp
  def <=>(o) = 0
end
cb = Box.new(Cmp.new)
p(case s("b") when ("a"...cb.lo) then :y else :n end)
nn = (b.lo..b.lo)
p nn === s("x"), nn.cover?(s("x")), nn === nil
