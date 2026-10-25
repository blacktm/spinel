# spinel: gc-stress
# A boxed instance of a BasicObject subclass is no Object and, without an
# include of Kernel, no Kernel: case/when, case/in, is_a?, kind_of? and ===
class Bare < BasicObject; end
class K < BasicObject
  include ::Kernel
end
class Shape; end
[Bare.new, K.new, Shape.new, 1].each do |x|
  a = case x
      when Object then "obj"
      else "no"
      end
  b = case x
      in Kernel then "kern"
      else "no"
      end
  c = case x
      when BasicObject then "bo"
      else "no"
      end
  puts "#{a} #{b} #{c}"
end
[K.new, Shape.new, 1].each do |x|
  puts "#{x.is_a?(Object)} #{x.kind_of?(Kernel)}"
end
puts [Bare.new, K.new, Shape.new, 1].count { |x| Object === x }
