# A handle slot that holds nil equals a nil read out of a container, as it
# equals a literal nil.
r, w = IO.pipe
none = r.wait_readable(0)
p [none == nil, none == [nil][0], none != [nil][0]]
p none.eql?([nil, 1][0])
p none.equal?([nil, 1][0])
p none == [0, nil][0]
live = w
p live == [nil][0]
p live == [w, 1][0]
h = { "a" => File.open("/dev/null") }
f = h["zz"]
p f == [nil][0]
h["a"].close
r.close
w.close
