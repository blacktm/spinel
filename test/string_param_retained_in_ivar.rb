# A string handed to a method and RETAINED in an ivar that is mutated in place
# has to stay the caller's string. The byref machinery only covered a callee
# that mutates the PARAMETER itself; one that merely stores it and mutates it
# later, through the ivar, left the caller holding a value copy and the two
# drifted apart (#4363). Both directions matter: the callee's mutation must
# reach the caller's name, and the caller's must reach the ivar.

class Holder
  attr_reader :bt
  def initialize(bt)
    @bt = bt
  end
  def bump
    @bt << "!"
  end
end

a = +"aaa"
h = Holder.new(a)
h.bump
p [h.bt, a]
a << "?"
p [h.bt, a]

# the same through a plain method rather than the constructor
class Sink
  attr_reader :s
  def initialize
    @s = +""
  end
  def take(x)
    @s = x
  end
  def bump
    @s << "!"
  end
end

b = +"bbb"
k = Sink.new
k.take(b)
k.bump
p [k.s, b]
b << "?"
p [k.s, b]

# a fresh string with no caller alias still works, and stays independent
g = Holder.new(+"ggg")
g.bump
p g.bt

# two holders over the same string see each other
c = +"ccc"
h1 = Holder.new(c)
h2 = Holder.new(c)
h1.bump
p [h1.bt, h2.bt, c]
