# A `case/in` class pattern written as a constant path (`in Mo::In`) tests
# the subject's class, as a bare constant does, for a boxed subject and a
# typed one. A constant path that holds a value (`in Float::INFINITY`,
# `in Mo::LIMIT`) is that value's ===.
def pv(x) = x
module Mo
  module Mix; end
  class In; end
  class Sub < In; include Mix; end
  module Deep; class K; end; end
  LIMIT = 5
  Sub2 = Struct.new(:x)
end
CAP = 7
class Plain; end
class W; def ==(o) = o == 5; end
class V; end
pv(1); pv("s"); pv(1.5); pv(W.new); pv(V.new); pv(Mo::In.new); pv(Mo::Sub.new); pv(Plain.new)

def row(v)
  [(case v; in Mo::In then 1; else 0; end),
   (case v; in Mo::Sub then 1; else 0; end),
   (case v; in Mo::Mix then 1; else 0; end),
   (case v; in Mo::Deep::K then 1; else 0; end),
   (case v; in ::Plain then 1; else 0; end),
   (case v; in Integer then 1; else 0; end)].join(",")
end
puts row(pv(1))
puts row(pv("s"))
puts row(pv(Mo::In.new))
puts row(pv(Mo::Sub.new))
puts row(pv(Plain.new))
puts row(pv(Mo::Deep::K.new))

puts(case pv(1); in Mo::In then 1; else 0; end)
puts(case pv(1); in Mo::In | Integer then 1; else 0; end)

s = Mo::Sub.new
puts(case s; in Mo::In then 1; else 0; end)
puts(case s; in Mo::Mix then 1; else 0; end)
puts(case s; in Mo::Deep::K then 1; else 0; end)
i = Mo::In.new
puts(case i; in Mo::Sub then 1; else 0; end)
puts(case 5; in Mo::In then 1; else 0; end)
puts(case "x"; in ::String then 1; else 0; end)

# a value constant: equality, for a typed subject and a boxed one
puts(case Float::INFINITY; in Float::INFINITY then 1; else 0; end)
puts(case 1.0; in Float::INFINITY then 1; else 0; end)
puts(case pv(Float::INFINITY); in Float::INFINITY then 1; else 0; end)
puts(case pv(1.0); in Float::INFINITY then 1; else 0; end)
puts(case 5; in Mo::LIMIT then 1; else 0; end)
puts(case 6; in Mo::LIMIT then 1; else 0; end)
puts(case pv(5); in Mo::LIMIT then 1; else 0; end)
puts(case pv("s"); in Mo::LIMIT then 1; else 0; end)
puts(case 5.0; in Mo::LIMIT then 1; else 0; end)
puts(case "x"; in Mo::LIMIT then 1; else 0; end)
puts(case 7; in CAP then 1; else 0; end)
puts(case 8; in CAP then 1; else 0; end)
puts(case pv(7); in CAP then 1; else 0; end)
# a number's === asks an object that is no number its own ==
puts(case W.new; in Mo::LIMIT then 1; else 0; end)
puts(case V.new; in Mo::LIMIT then 1; else 0; end)
puts(case pv(W.new); in Mo::LIMIT then 1; else 0; end)
puts(case pv(V.new); in Mo::LIMIT then 1; else 0; end)
e = "a".encoding
puts(case e; in Encoding::UTF_8 then 1; else 0; end)
puts(case 3; in Encoding::UTF_8 then 1; else 0; end)

# a constant path with a key pattern tests the class first
z = Mo::Sub2.new(3)
puts(case z; in Mo::Sub2(x:) then x; else 0; end)
puts(case pv(z); in Mo::Sub2(x:) then x; else 0; end)
puts(case pv(1); in Mo::Sub2(x:) then x; else 0; end)

# a value constant is its own ===: a Range, a Proc, a Comparable
class Foo; end
class Bar < Foo; end
class C1; include Comparable; def initialize(v) = @v = v; def <=>(o) = @v <=> o; end
module Mo
  K = Foo
  RNG = 1..3
  ERNG = (1..)
  RNGF = 1.0..2.0
  SRNG = "a".."c"
  POS = ->(x) { x > 0 }
  NILC = nil
  SYM = :a
  STR = "s"
  IA = [1, 2]
  EA = []
end
SYMB = :a
NILB = nil
def mi(b) = b ? 5 : nil
def ms(b) = b ? "s" : nil
puts(case 2; in Mo::RNG then 1; else 0; end)
puts(case 5; in Mo::RNG then 1; else 0; end)
puts(case pv(2); in Mo::RNG then 1; else 0; end)
puts(case 9; in Mo::ERNG then 1; else 0; end)
puts(case 1.5; in Mo::RNGF then 1; else 0; end)
puts(case "b"; in Mo::SRNG then 1; else 0; end)
puts(case 3; in Mo::POS then 1; else 0; end)
puts(case -3; in Mo::POS then 1; else 0; end)
puts(case C1.new(5); in Mo::LIMIT then 1; else 0; end)
puts(case pv(C1.new(5)); in Mo::LIMIT then 1; else 0; end)
puts(case :a; in Mo::SYM then 1; else 0; end)
puts(case :b; in SYMB then 1; else 0; end)
puts(case pv("s"); in Mo::STR then 1; else 0; end)
puts(case pv(nil); in NILB then 1; else 0; end)
puts(case mi(true); in Mo::LIMIT then 1; else 0; end)
puts(case mi(false); in Mo::LIMIT then 1; else 0; end)
puts(case mi(false); in Mo::NILC then 1; else 0; end)
puts(case ms(false); in Mo::NILC then 1; else 0; end)
puts(case ms(true); in Mo::NILC then 1; else 0; end)
puts(case [1.0, 2.0]; in Mo::IA then 1; else 0; end)
puts(case ["x"].reject { true }; in Mo::EA then 1; else 0; end)
puts(case 7; in CAP | 8 then 1; else 0; end)

# a path to a class alias names that class
puts(case Foo.new; in Mo::K then 1; else 0; end)
puts(case Bar.new; in Mo::K then 1; else 0; end)
puts(case 1; in Mo::K then 1; else 0; end)
puts(case pv(Bar.new); in Mo::K then 1; else 0; end)

# a constant path that misses raises with the === message
class Pt; end
[-> { 3 => Mo::LIMIT }, -> { 3 => Mo::In }, -> { 3 => Float::INFINITY },
 -> { Pt.new => Mo::In }].each do |f|
  f.call
rescue NoMatchingPatternError => e
  puts e.message.sub(/0x\h+/, "X").sub(/0x\h+/, "X")
end
