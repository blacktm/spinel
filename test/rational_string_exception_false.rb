# Rational(String, exception: false) answers nil for a String it cannot
# convert -- a zero or empty denominator, text after the number, no digits
# -- typed or through an Array element; a valid String converts
def t(label)
  p yield
rescue ZeroDivisionError, ArgumentError => e
  puts "#{label}: #{e.class}"
end
%w[1/0 1/00 1.5/0 1/ 1/2x abc 1/2 3 2.5 1_0/3].each { |s| t(s) { Rational(s, exception: false) } }
a = ["1/0", "abc", "3/4", 3]
a.each_with_index { |v, k| t("boxed #{k}") { Rational(v, exception: false) } }
t("raise zero") { Rational("1/0") }
t("raise text") { Rational("1/2x") }
t("boxed raise") { Rational(a[0], exception: true) }
t("to_r") { "1/0".to_r }
# exception: true is the strict parse; a denominator takes a fraction and an
# exponent; a raise from a soft parse leaves later strict parses strict
t("true zero") { Rational("1/0", exception: true) }
f = [true, false][0]
t("true text") { Rational("1/2x", exception: f) }
t("denominator fraction") { Rational("1/0.5", exception: false) }
t("denominator exponent") { Rational("1/2e3") }
t("denominator zero fraction") { Rational("1/0.0", exception: false) }
t("not a boolean") { Rational("1/2", exception: nil) }
