class Foo; end
# Keep the object layout used by the complete supplied programs.
anchor = [Foo.new, 1]

def float_string
  case 1.5; in "abc"; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def float_string_range
  case 1.5; in "a".."z"; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def string_integer
  case "abc"; in 3; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def string_float
  case "abc"; in 1.5; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def string_symbol
  case "abc"; in :ab; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def find_string_integer
  case ["a", "b"]; in [*, 3, *]; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def object_float
  case Foo.new; in 1.5; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def range_integer
  case (1..4); in 3; end
  :matched
rescue NoMatchingPatternError
  :miss
end

def range_pin
  pin = (1..4)
  case (1..4); in ^pin; end
  :matched
rescue NoMatchingPatternError
  :miss
end

p [float_string, float_string_range, string_integer, string_float, string_symbol, find_string_integer, object_float, range_integer, range_pin]
# a pinned Proc or an object with its own ===, and pinned struct values
pin_pr = ->(x) { x == 5 }
p(case 5; in ^pin_pr then :proc_hit; else :proc_miss; end)
class PinEq; def ===(o) = o == 5; end
pin_m = PinEq.new
p(case 5; in ^pin_m then :user_hit; else :user_miss; end)
pin_k = Integer
p(case Integer; in ^pin_k then :cls_hit; else :cls_miss; end)
p(case 5; in ^pin_k then :inst_hit; else :inst_miss; end)
pin_h = Rational(1, 2)
p(case Rational(1, 2); in ^pin_h then :rat_hit; else :rat_miss; end)
pin_rg = (1..3)
p(case (1..3); in ^pin_rg then :rng_hit; else :rng_miss; end)
