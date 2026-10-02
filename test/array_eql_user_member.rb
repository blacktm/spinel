class Needle
  def eql?(other)
    other == :hit
  end
end
p [Needle.new].eql?([:hit])
p [Needle.new].eql?([:miss])
p [:hit].eql?([Needle.new])
p [[Needle.new], 1].eql?([[:hit], 1])
p [Needle.new].eql?([:hit, :extra])
p [1].eql?([1.0])

class Child < Needle
end
p [Child.new].eql?([:hit])

class EqualOnly
  def ==(other)
    true
  end
end
x = EqualOnly.new
p [[x].eql?([x]), [x].eql?([EqualOnly.new])]

class Truthy
  def eql?(other)
    :yes
  end
end
p [Truthy.new].eql?([:anything])

class Collecting
  def eql?(other)
    print "E"
    GC.start
    other == :hit
  end
end
p [Collecting.new, Collecting.new].eql?([:hit, :hit])
p [Collecting.new, Collecting.new].eql?([:miss, :hit])
