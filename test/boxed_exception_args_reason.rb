# args and private_call? on a NoMethodError, and reason on a
# LocalJumpError, read out of a container answer as on a typed exception.
e = begin; nil.foo(1, 2); rescue NoMethodError => ex; ex; end
x = [e, 0][0]
p x.args
p x.private_call?
n = [NoMethodError.new("m", :zz, [3], true), 0][0]
p [n.args, n.private_call?]
def need_block = yield
l = begin; need_block; rescue LocalJumpError => ex; ex; end
y = [l, 0][0]
p y.reason
r = [RuntimeError.new("r"), 0][0]
p (r.args rescue $!.message)
p (r.reason rescue $!.message)
