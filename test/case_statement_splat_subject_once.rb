$s = 0
def subj; $s += 1; [1, 2]; end
list = [[1, 2], [3]]
case subj when *list then p :s_hit else p :s_no end
p $s
r = case subj when *list then :v_hit else :v_no end
p [r, $s]
ints = [1, 2, 3]
