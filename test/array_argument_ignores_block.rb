# spinel: gc-stress
# An Array quantifier, count or find_index given both a pattern or value
# argument and a block uses the argument, warns that the block is unused
# (after the receiver and argument run, where $stderr points), and never
# runs the block.
p [1, 2].any?(1) { false }
p [1, 2].one?(1) { false }
p [1, 2].count(1) { false }
p [1, 2].find_index(1) { false }
p [1, 2].all?(Integer) { false }
p [1, 2].none?(3) { true }
p [1, 2].find_index(9) { true }
p %w[a b a].count("a") { raise "block run" }
def recv
  puts "recv"
  [1, 2, 1]
end
def arg
  puts "arg"
  1
end
p recv.count(arg) { raise "block run" }
a = [1, 2]
p a&.count(1) { false }
m = ARGV.size > 9 ? [1] : nil
p m&.count(1) { raise "block run" }
begin
  p a.count(1 / 0) { raise "block run" }
rescue ZeroDivisionError => e
  p e.class
end
class Bag
  include Enumerable
  def initialize(*a) = @a = a
  def each(&b) = @a.each(&b)
end
p Bag.new(1, 2, 1).count(1) { false }
p a.each_slice(1).count([1]) { false }
pr = proc { false }
p a.count(1, &pr)
p a.any?(1, &:odd?)
p a.count(*[1]) { false }
require "stringio"
old = $stderr
$stderr = StringIO.new
p a.count(2) { false }
s = $stderr.string
$stderr = old
p s.sub(/\A.*?:\d+: /, "")
$VERBOSE = nil
p [1, 2].any?(2) { false }
