# A leading 0 before a digit makes Integer() and to_i(0) read octal, so "08"
# and "09" are no Integer to Integer() and 0 to to_i(0), as in CRuby.
p (Integer("08") rescue [$!.class, $!.message])
p (Integer("-09") rescue [$!.class, $!.message])
p Integer("010")
p Integer("0o17")
p Integer("08", 10)
p "08".to_i(0)
p "019".to_i(0)
p "08".to_i
p Integer("0")
p Integer("0x1f")
