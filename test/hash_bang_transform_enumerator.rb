# spinel: gc-stress
h = {a: 1}
e = h.transform_keys!
p [e.class, e.size, e.to_a, h]

values = {a: 1, b: 2}
enum = values.transform_values!
p [enum.class, enum.size, values]
result = enum.each { |value| value.to_s }
p [result.equal?(values), values]

keys = {a: 1}
alias_hash = keys
external = keys.transform_keys!
p [external.next, keys]
external.feed(false)
begin
  external.next
rescue StopIteration => stop
  p [stop.result.equal?(keys), alias_hash]
end
