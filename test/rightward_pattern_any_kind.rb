# The rightward pattern `expr => pattern` as a statement, for every pattern
# kind other than a flat array or hash pattern: a class, a capture, an
# alternation, a value, a range, a pin and a find pattern. On 18c4cc7e none
# of these statements evaluated its value or tested it: the log below held
# only the two values the target and array forms read, the capture bound
# nil, and none of the seven misses raised. It should print what the
# .expected holds.
$log = []
def vi(x) = ($log << x; x)
def vs(x) = ($log << x; x)
def va(x) = ($log << x.size; x)

vi(1) => a
puts "target #{a.inspect}"
vs("s") => String
vs("s2") => String => b
puts "capture #{b.inspect}"
vi(5) => Integer | Float
vi(6) => 6
vi(7) => 1..9
c = 8
vi(8) => ^c
va([1, 3, 4]) => [*, 3, *]
va([1, 2]) => [x, y]
puts "array #{x} #{y}"
[1, 2, 3].each { |i| vi(i * 10) => Integer => j; print j, " " }
puts
p $log

def t1
  vi(1) => String
  nil
end

def t2
  vs("z") => Integer
  nil
end

def t3
  vi(5) => 7
  nil
end

def t4
  vi(50) => 1..9
  nil
end

def t5
  c = 3
  vi(6) => ^c
  nil
end

def t6
  va([1]) => [*, 3, *]
  nil
end

def t7
  vi(9) => Float | String
  nil
end

# an endless def followed by `=> Symbol` matches the def's name, and the
# method is still defined once
def tdef(x) = x => Symbol
p tdef(1)

misses = []
begin; t1; rescue NoMatchingPatternError; misses << 1; end
begin; t2; rescue NoMatchingPatternError; misses << 2; end
begin; t3; rescue NoMatchingPatternError; misses << 3; end
begin; t4; rescue NoMatchingPatternError; misses << 4; end
begin; t5; rescue NoMatchingPatternError; misses << 5; end
begin; t6; rescue NoMatchingPatternError; misses << 6; end
begin; t7; rescue NoMatchingPatternError; misses << 7; end
p misses
p $log.size
