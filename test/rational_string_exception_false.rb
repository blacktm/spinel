# Rational(str, exception: false) answers nil for every string it cannot
# convert, a zero denominator, a missing one and trailing text included, as
# CRuby does; without the keyword a zero denominator still raises.
p Rational("1/0", exception: false)
p Rational("1/", exception: false)
p Rational("1x", exception: false)
p Rational("x", exception: false)
p Rational("3/4", exception: false)
p Rational(" 5 ", exception: false)
p (Rational("1/0") rescue [$!.class, $!.message])
