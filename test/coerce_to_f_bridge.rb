# Integer#coerce converts an object answering to_f in a program that names
# neither Integer() nor Float(), as CRuby does.
class C
  def to_f
    1.5
  end
end
p 5.coerce(C.new)
p 5.coerce(2)
p 5.coerce(2.5)
p (5.coerce(Object.new) rescue [$!.class, $!.message])
