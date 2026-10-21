e = (1..3).bsearch
p [e.class, e.to_a]
e = (0..100).bsearch
p e.each { |x| x >= 35 }
p e.each { |x| 50 <=> x }
p e.next, e.peek
p (1..3).bsearch.inspect
p (1..2.5).bsearch.each { |x| x >= 2 }
p e.each { |x| Rational(50 - x, 3) }
