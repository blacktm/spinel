# Complex.rect / .rectangular / .polar raise TypeError "not a real" for an
# argument that is not a real number, in either position, once both are
# evaluated; a real number or a Complex with a zero imaginary part converts
def t(label)
  p yield
rescue TypeError => e
  puts "#{label}: #{e.class}: #{e.message}"
end
t("rect 1, nil") { Complex.rect(1, nil) }
t("rectangular nil, 1") { Complex.rectangular(nil, 1) }
t("rect nil") { Complex.rect(nil) }
t("polar 1, nil") { Complex.polar(1, nil) }
t("polar nil") { Complex.polar(nil) }
t("rect str") { Complex.rect("1", 2) }
t("polar sym") { Complex.polar(1, :a) }
t("rect arr") { Complex.rect(1, [1]) }
t("rect true") { Complex.rect(true) }

a = [nil, 1, "s", 2.5]
t("rect boxed nil") { Complex.rect(1, a[0]) }
t("polar boxed nil") { Complex.polar(a[0]) }
t("rect boxed str") { Complex.rect(a[2], 1) }
t("rect boxed nums") { Complex.rect(a[1], a[3]) }
t("polar boxed num") { Complex.polar(a[1]) }

def none = nil
t("rect method nil") { Complex.rect(1, none) }
log = []
t("order") { Complex.rect((log << :a; nil), (log << :b; 2)) }
p log
t("rect 1, 2") { Complex.rect(1, 2) }
t("rect 1.5") { Complex.rect(1.5) }
t("rect complex real") { Complex.rect(Complex(3, 0), 1) }
t("rect complex imag") { Complex.rect(Complex(3, 1), 1) }
t("polar 2") { Complex.polar(2) }

# a boxed instance of a Numeric subclass is a real
class RealN < Numeric
  def real? = true
  def to_f = 1.0
end
na = [RealN.new, 1]
t("rect numeric subclass") { Complex.rect(na[0], 1).imaginary }

# a nullable Integer or Float that is nil is no real either, checked after
# both arguments run
def maybe(x) = x > 0 ? x : nil
t("rect nullable nil") { Complex.rect(maybe(-1), (puts "second"; 2)) }
t("polar nullable float") { Complex.polar([1.5, 2.5][5]) }
p Complex.rect(maybe(3), 1)
