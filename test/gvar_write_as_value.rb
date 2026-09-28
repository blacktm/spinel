# A global assignment used as a value answers the value assigned, as in
# CRuby, where the compiler refused it.
p($g = 5)
x = ($h = "s")
p x
def f = ($k = [1])
p f
p "#{$m = 3}"
p [$g, $h, $k, $m]
