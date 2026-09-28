# A case statement whose `when *list` splats a mixed Array evaluates its
# subject once, as CRuby does and as the case value already did.
$n = 0
def subj
  $n += 1
  [3, "s"][0]
end
list = [[1, "a"][0], [3, "b"][0]]
case subj
when *list then p :hit
else p :miss
end
p $n
$n = 0
case subj
when 9, *list then p :hit2
end
p $n
def num
  $n += 1
  4
end
$n = 0
case num
when *list then p :no
else p :miss
end
p $n
