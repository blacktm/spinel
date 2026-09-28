# The FrozenError a frozen Hash raises names it, as CRuby's does, for a
# typed Hash and for one read out of a container, and keeps it as the
# error's receiver.
h = { a: 1, "b" => [2] }.freeze
def msg
  yield
  "no raise"
rescue FrozenError => e
  e.message
end
p msg { h[:c] = 3 }
x = [h, 0][0]
p msg { x.merge!({ c: 3 }) }
p msg { x.shift }
p msg { x.transform_values! { |v| v } }
e = begin; x.merge!({ c: 3 }); rescue FrozenError => err; err; end
p e.receiver.equal?(h)
p msg { {}.freeze[:k] = 1 }
