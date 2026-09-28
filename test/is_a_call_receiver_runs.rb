# An is_a?, kind_of? or instance_of? test on a receiver that is a method call
# runs the call even where the answer is known from the class, in an if, an
# unless, a ternary and an elsif.
module Named; end
class Item; include Named; def initialize; @v = 1; end; end
class Other; end
$n = 0
def mk
  $n += 1
  Item.new
end
puts(mk.is_a?(Named) ? "t-yes" : "t-no")
p $n
if mk.is_a?(Named) then puts "if-yes" end
p $n
if mk.kind_of?(Item) then puts "kind-yes" end
p $n
if mk.is_a?(Other) then puts "o-yes" else puts "o-no" end
p $n
puts "u-no" unless mk.instance_of?(Item)
p $n
if $n > 100 then puts "big" elsif mk.is_a?(Named) then puts "elsif-yes" end
p $n
x = mk
if x.is_a?(Named) then puts "local-yes" end
p $n
