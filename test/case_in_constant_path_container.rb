# A constant path inside an array or a hash pattern (`in [Mo::In]`,
# `in {a: Mo::In}`) is the class or value test it is at the top level.
module Mo
  class In; end
  LIMIT = 5
end
class W; def ==(o) = o == 5; end
puts(case [Mo::In.new]; in [Mo::In] then 1; else 0; end)
puts(case [1]; in [Mo::In] then 1; else 0; end)
puts(case({a: Mo::In.new}); in {a: Mo::In} then 1; else 0; end)
puts(case({a: 1}); in {a: Mo::In} then 1; else 0; end)
puts(case [W.new]; in [Mo::LIMIT] then 1; else 0; end)
puts(case [6]; in [Mo::LIMIT] then 1; else 0; end)
CAP = 7
puts(case [7]; in [CAP] then 1; else 0; end)
puts(case [7, 1]; in [CAP, Integer] then 1; else 0; end)
puts(case({k: 7}); in {k: CAP} then 1; else 0; end)
puts(case [[7]]; in [[CAP]] then 1; else 0; end)
puts(case [:x, 7]; in [Symbol, CAP] then 1; else 0; end)
module Mo; RNG = 1..3; end
puts(case [2]; in [Mo::RNG] then 1; else 0; end)
puts(case [5]; in [Mo::RNG] then 1; else 0; end)
