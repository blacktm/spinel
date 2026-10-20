# A blockless cycle of an endless Range is an endless Enumerator over the
# Range: it never finishes its first round, so it streams the Range itself.
begin
  p((1..).cycle.first(3))
rescue => error
  p [error.class, error.message]
end

e = (4...).cycle
p [e.class, e.size, e.first(0)]
p e.first(4)
p e.take(3)
p e.next, e.peek, e.next
p e.rewind.equal?(e)
p e.next
p e

c = (1..).cycle
p c.lazy.map { |x| x * 2 }.first(3)
p c.with_index(10).first(3)
p c.find { |x| x > 3 }
p c.take_while { |x| x < 4 }
p c.first

def cyc(o) = o.cycle
p cyc(2..).first(4)
p cyc(2..).size
p cyc(1..2).first(5)
p cyc([:a, :b]).first(3)

def start
  puts "start"
  3
end
p((start..).cycle.first(3))
p((-3...).cycle.first(4))
p((0..).cycle.take(0))
begin
  p((1..).cycle.first(-1))
rescue => error
  p [error.class, error.message]
end

q = [(1..).cycle, 0][0]
p q.first(3)
class Holder; def initialize; @e = (1..).cycle; end; def t = @e.first(2); end
p Holder.new.t
r = []
(1..).cycle.each_with_index { |x, i| r << [x, i]; break if i == 2 }
p r
p (5..).cycle.each_slice(2).first(2)
