# source_location on a Method or an UnboundMethod read out of a container
# answers [file, line] of its definition, as on a typed one.
def m(a, b = 1); end
def n; end
x = [method(:m), 0][0]
loc = x.source_location
p [loc[0].end_with?("boxed_method_source_location.rb"), loc[1]]
p [method(:n), 0][0].source_location[1]
u = [method(:m).unbind, 0][0]
p u.source_location[1]
p x.source_location == method(:m).source_location
p ([nil, 0][0].source_location rescue $!.message)
