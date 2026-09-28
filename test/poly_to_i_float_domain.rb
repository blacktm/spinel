# to_i on a NaN or an infinite Float read out of a container raises
# FloatDomainError naming it, as CRuby does and as truncate already did.
x = [0.0 / 0, 1][0]
p (x.to_i rescue [$!.class, $!.message])
y = [1.0 / 0, 1][0]
p (y.to_i rescue [$!.class, $!.message])
z = [-1.0 / 0, "s"][0]
p (z.to_i rescue [$!.class, $!.message])
p (z.truncate rescue [$!.class, $!.message])
p [2.9, 1][0].to_i
