# a bare break answers nil whatever the tail's kind; a valued break its
# value; a break bound to a nested loop or block does not count
class Kinds
  def initialize; @f = 1.5; @s = :sym; @t = "str"; @i = 3; end
end
o = Kinds.new
p(o.instance_eval { break; @f })
p(o.instance_eval { break; @s })
p(o.instance_eval { break; @t })
p(o.instance_exec(2) { |x| break if x > 1; @i })
p(o.instance_exec(0) { |x| break if x > 1; @i })
p(o.instance_eval { break 7; @i })
p(o.instance_eval { [1, 2].each { |y| break if y == 1 }; @i })
p(o.instance_eval { while true; break; end; @i })
