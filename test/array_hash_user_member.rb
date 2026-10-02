class Needle
  def hash
    :hit.hash
  end
end
p [Needle.new].hash == [:hit].hash
p [[Needle.new], 1].hash == [[:hit], 1].hash
p [Needle.new, Needle.new].hash == [:hit, :hit].hash

class Child < Needle
end
p [Child.new].hash == [:hit].hash

class AliasHash
  def fingerprint
    :hit.hash
  end
  alias hash fingerprint
end
p [AliasHash.new].hash == [:hit].hash

class Collecting
  def hash
    print "H"
    GC.start
    :hit.hash
  end
end
p [Collecting.new, Collecting.new].hash == [:hit, :hit].hash

# A shared hash does not change default equality or merge distinct objects.
a = Needle.new
b = Needle.new
p [a, b].uniq.length
p [a, a].uniq.length
h = {a => :first, b => :second}
p [h.length, h[a], h[b]]
