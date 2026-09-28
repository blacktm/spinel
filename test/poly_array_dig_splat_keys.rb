# dig with a splat beside other keys on a mixed Array walks every key in
# order, the splat's elements in its place, as CRuby does.
a = [[1, [2, 3]], "s", { k: [4, 5] }]
ix = [0]
p a.dig(*ix, 1, 0)
p a.dig(*ix, 1)
p a.dig(2, *[:k], 1)
kk = [:k]
p a.dig(2, *kk, 0)
p a.dig(*ix, *[1], 1)
p a.dig(*ix, 5, 0)
p (a.dig(*ix, 0, 0) rescue [$!.class, $!.message])
$log = []
def r(x)
  $log << :r
  x
end
def k(x)
  $log << :k
  x
end
p r(a).dig(*k([0]), 1)
p $log
