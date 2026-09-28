# `when Integer` and `in Integer` match a Bignum read out of a container, as
# they match a Fixnum there and as CRuby matches both.
def kind(v)
  case v
  when Integer then :int
  when Float then :float
  else :other
  end
end
def pat(v)
  case v
  in Integer => n then [:int, n + 1]
  in String then :str
  else :other
  end
end
xs = [2**70, -(2**64), 5, 1.5, "s"]
p xs.map { |v| kind(v) }
p xs.map { |v| pat(v) }
b = [2**70, "s"][0]
p(case b when Integer then b * 2 else nil end)
def hpat(h)
  case h
  in { n: Integer } then :yes
  else :no
  end
end
p hpat({ n: 2**65, s: "t" })
def apat(a)
  case a
  in [Integer, String] then :pair
  else :no
  end
end
p apat([2**66, "u"])
