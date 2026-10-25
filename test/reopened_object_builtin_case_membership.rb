# `when Object` / `in Object` in a program that reopens Object
class Object; def hi = "hi"; end
o = Object.new
puts "1 " + (case o; in Object then "o-obj"; else "other"; end)
puts "2 " + (case o; when Object then "o-w-obj"; else "other"; end)
puts "3 " + (case o; in BasicObject then "o-basic"; else "other"; end)
puts "4 " + (case o; when BasicObject then "o-w-basic"; else "other"; end)
puts "5 " + (case o; in Kernel then "o-kernel"; else "other"; end)

# every boxed value is an Object, except a BasicObject.new and an instance
# of a class that descends from BasicObject
class Bare < BasicObject; end
class Bare2 < Bare; end
class Shape; end
class Err < StandardError; end
Pt = Struct.new(:x)
class Kid < Array; end
vals = [Shape.new, Err.new("e"), Pt.new(1), Kid.new, String, :s, 1, 1.5, "str",
        nil, [1], {a: 1}, 1..2, Object.new, BasicObject.new, Bare.new, Bare2.new]
vals.each_with_index do |v, i|
  w = case v
      when Object then "obj"
      else "not-obj"
      end
  m = case v
      in Object then "obj"
      else "not-obj"
      end
  puts "#{i} when:#{w} in:#{m}"
end
BO = BasicObject
class BareA < BO; end
ba = [BareA.new, 1][0]
puts(case ba; when Object then "obj"; else "no"; end)
puts(case ba; in Object then "obj"; else "no"; end)
