# spinel: gc-stress
# `when *list` in a statement-form case matches each element through its ===
class Shape; end
class Sq < Shape; end
s = Sq.new
L1 = [Integer, Shape]
L2 = [Integer, Object]
puts(case s; when *L1 then "splat-shape"; else "other"; end)
puts(case s; when *[String, Shape] then "splat-lit-shape"; else "other"; end)
puts(case s; when *L2 then "splat-object"; else "other"; end)
puts(case s; when *[String, Kernel] then "splat-lit-kernel"; else "other"; end)
puts(case s; when String, *[BasicObject] then "mixed-splat-basic"; else "other"; end)
x = case s
    when *L2 then "expr-splat-object"
    else "other"
    end
puts x
case s
when *[Integer, BasicObject] then puts "stmt-splat-basic"
else puts "other"
end
case s
when *[String, Integer] then puts "wrong"
else puts "stmt-splat-miss"
end

# the other builtin patterns a statement-form splat holds
case "abc"
when *[/b/, 1] then puts "regexp #{$~[0]}"
else puts "regexp-miss"
end
case 5
when *[1..6, "x"] then puts "range"
else puts "range-miss"
end
v = nil
case v
when *[NilClass, 1] then puts "nilclass"
else puts "nilclass-miss"
end
case :sym
when *[Symbol, 2] then puts "symbol"
else puts "symbol-miss"
end
case 2.5
when *[Numeric, "q"] then puts "numeric"
else puts "numeric-miss"
end
module Mixin; end
class WithMixin; include Mixin; end
case WithMixin.new
when *[Mixin, 1] then puts "module"
else puts "module-miss"
end

# an element equal to the subject still matches
class Pt
  attr_reader :x
  def initialize(x) = @x = x
  def ==(o) = o.is_a?(Pt) && o.x == x
end
case Pt.new(1)
when *[Pt.new(1), "z"] then puts "equal-element"
else puts "equal-miss"
end
# the subject runs once, however many `when *` arms test it
q = ["a", 1, :s, 2.5]
case q.shift
when *[Integer, 1] then puts "int"
when *[String, 1] then puts "str"
end
p q
