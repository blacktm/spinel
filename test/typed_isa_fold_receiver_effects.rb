module Named; end
class Item; include Named; def initialize; @v = 1; end; end
$n = 0
def mk; $n += 1; Item.new; end
puts(case mk; in Named then "in-yes"; else "in-no"; end); puts $n
puts(case mk; when Named then "wv-yes"; else "wv-no"; end); puts $n
case mk
when Named then puts "w-yes"
end
puts $n
r = (mk in Named); puts r; puts $n
puts(mk.is_a?(Named) ? "t-yes" : "t-no"); puts $n
if mk.is_a?(Named) then puts "if-yes" end
puts $n
# a receiver that can raise is evaluated too
class Foo; end
nn = 6
dd = ARGV.size
r = begin
  (nn / dd).is_a?(Foo) ? :foo : :not_foo
rescue ZeroDivisionError => e
  [:raised, e.class]
end
p r
r = begin
  if (nn % dd).is_a?(Foo) then :foo else :not_foo end
rescue ZeroDivisionError => e
  [:raised, e.class]
end
p r
