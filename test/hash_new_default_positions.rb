# `Hash.new(default)` has no element types of its own: the variant is decided
# by what is written into it. Two positions had nothing to decide from and
# emitted the "undefined method 'new' for class Hash" refusal instead (#4291).
#
# A method's VALUE: `def mk = Hash.new(0)` has no receiver use, so inference
# left it unknown and the method emitted as void.
#
# An IVAR write: the slot was already typed from the later `@h[k]` uses -- the
# C struct held the right hash -- while the Hash.new node itself stayed
# unknown, so the constructor refused to build what the slot expected.
#
# (Hash#inspect is avoided here: its spacing differs between ruby versions.)

class Counter
  def initialize
    @counts = Hash.new(0)
  end

  def bump(key)
    @counts[key] += 1
    @counts
  end
end

p Counter.new.bump(:a)[:a]

c = Counter.new
c.bump(:a)
c.bump(:a)
c.bump(:b)
p [c.bump(:a)[:a], c.bump(:b)[:b]]
p c.bump(:a).size

def mk = Hash.new(0)
p mk.size
p mk[:missing]

def mk_plain = Hash.new
p mk_plain.size
p mk_plain[:missing].nil?

# the positions that already worked
x = Hash.new(0)
x[:k] += 2
p x[:k]
p x.size

class Holder
  def initialize
    @h = Hash.new("none")
  end

  def get(k) = @h[k]
  def put(k, v)
    @h[k] = v
    @h
  end
end

h = Holder.new
p h.get("absent")
p h.put("a", "b")["a"]
p h.get("still absent")
