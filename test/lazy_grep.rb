# spinel: gc-stress
require "set"
# Enumerator::Lazy#grep filters each element with pattern === element and
# maps the matches through its block when it has one.
p [1, "s"].lazy.grep(Integer).to_a
p [1, "s", 2].lazy.grep(Integer) { |n| n * 2 }.to_a
p [1, "s", 2].lazy.grep(Integer).first
p [1, "s", 2].lazy.grep(Integer).first(2)
p (1..5).lazy.grep(2..3).to_a
p (1..).lazy.grep(3..5).first(2)
p (1..10).lazy.map { |x| x * 2 }.grep(4..8).to_a
p (1..10).lazy.grep(3..6).take(2).to_a
p %w[apple bob cat].lazy.grep(/a/).to_a
p %w[ab cd].lazy.grep(/(a)/) { $1 }.to_a
p [1, 2.5, "x", :y, nil].lazy.grep(Numeric).to_a
p [:a, :b].lazy.grep(:a).to_a
p (1..5).lazy.grep(2..3).force

e = Enumerator.new { |y| y << 1; y << "a"; y << 3 }
p e.lazy.grep(Integer).first(2)

l = (1..10).lazy.grep(2..4)
p l.first(2)

# the source is evaluated before the pattern, each once
$log = []
def source
  $log << :source
  [1, "s"]
end
def pattern
  $log << :pattern
  Integer
end
p source.lazy.grep(pattern).to_a
p $log

# the pattern's own #===: a Proc, a Set, a user object, and the Class and
# Range patterns above in a program that defines #===
class Above
  def initialize(n) = @n = n
  def ===(x) = x.is_a?(Integer) && x > @n
end
p (1..6).lazy.grep(->(x) { x.even? }).to_a
p (1..6).lazy.grep(Set[2, 4]).to_a
p [1, "s", 3, 4, 5].lazy.grep(Above.new(2)).to_a
p (1..).lazy.grep(Above.new(3)) { |n| n * 10 }.first(2)
p [1, "s", 2.5].lazy.grep(Integer).to_a

# a Hash, a user Enumerable and builtin Enumerators as sources
p({a: 1, b: 2}.lazy.grep(Array).to_a)
class Three
  include Enumerable
  def each; yield 1; yield "s"; yield 3; end
end
p Three.new.lazy.grep(Integer) { |x| x + 1 }.to_a
p "a\nbc\nd".each_line.lazy.grep(/b/).to_a
p %w[a b c].each_with_index.lazy.grep(Array).first
p [[1, 2], [3, 4]].lazy.grep(Array) { |a, b| a + b }.to_a

# a Module, a String, an Integer, NilClass and an object's own #=== as patterns
module Tag; end
class Tagged; include Tag; end
p [Tagged.new, 1].lazy.grep(Tag).to_a.size
p [1, "x", "y", :x].lazy.grep("x").to_a
p [1, 2, 3].lazy.grep(2).to_a
p [nil, false, 1].lazy.grep(NilClass).to_a
long = Object.new
def long.===(x) = x.to_s.size > 1
p [1, 22, 333].lazy.grep(long).to_a
