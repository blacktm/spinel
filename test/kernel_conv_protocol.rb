# Kernel#Integer and Kernel#Float on a user object: the object's own
# conversion methods, probed in CRuby's order, each answer judged the way
# CRuby judges it, in the strict and the `exception: false` forms.
$calls = []
def note(name) = $calls << name

def try
  r = yield
  puts "=> #{r.inspect}"
rescue => e
  puts "=> #{e.class}: #{e.message}"
end

def show(label)
  $calls = []
  print label, " "
  yield
  puts "   calls: #{$calls.inspect}" unless $calls.empty?
end

# --- #to_int answers ---------------------------------------------------
class IntAnswer;   def to_int; note(:to_int); 7; end; end
class BigAnswer;   def to_int; note(:to_int); 1 << 70; end; end
class NilAnswer;   def to_int; note(:to_int); nil; end; end
class NilThenToI;  def to_int; note(:to_int); nil; end; def to_i; note(:to_i); 5; end; end
class StrAnswer;   def to_int; note(:to_int); "7"; end; end
class StrThenToI;  def to_int; note(:to_int); "7"; end; def to_i; note(:to_i); 5; end; end
class RaisesToInt; def to_int; note(:to_int); raise "boom"; end; end
class RaiseThenToI; def to_int; note(:to_int); raise "boom"; end; def to_i; note(:to_i); 5; end; end

# --- #to_i alone --------------------------------------------------------
class ToIOnly;     def to_i; note(:to_i); 5; end; end
class ToIBig;      def to_i; note(:to_i); 1 << 70; end; end
class ToIString;   def to_i; note(:to_i); "7"; end; end
class ToINil;      def to_i; note(:to_i); nil; end; end
class ToIRaises;   def to_i; note(:to_i); raise "boom"; end; end

# --- #to_str ------------------------------------------------------------
class StrConv;     def to_str; note(:to_str); "12"; end; end
class BadStrConv;  def to_str; note(:to_str); "zz"; end; end
class StrAndToI;   def to_str; note(:to_str); "12"; end; def to_i; note(:to_i); 99; end; end
class WrongStrConv; def to_str; note(:to_str); 3; end; end
class Plain; end

show("Integer(IntAnswer)")    { try { Integer(IntAnswer.new) } }
show("Integer(BigAnswer)")    { try { Integer(BigAnswer.new) } }
show("Integer(NilAnswer)")    { try { Integer(NilAnswer.new) } }
show("Integer(NilThenToI)")   { try { Integer(NilThenToI.new) } }
show("Integer(StrAnswer)")    { try { Integer(StrAnswer.new) } }
show("Integer(StrThenToI)")   { try { Integer(StrThenToI.new) } }
show("Integer(RaisesToInt)")  { try { Integer(RaisesToInt.new) } }
show("Integer(RaiseThenToI)") { try { Integer(RaiseThenToI.new) } }
show("Integer(ToIOnly)")      { try { Integer(ToIOnly.new) } }
show("Integer(ToIBig)")       { try { Integer(ToIBig.new) } }
show("Integer(ToIString)")    { try { Integer(ToIString.new) } }
show("Integer(ToINil)")       { try { Integer(ToINil.new) } }
show("Integer(ToIRaises)")    { try { Integer(ToIRaises.new) } }
show("Integer(StrConv)")      { try { Integer(StrConv.new) } }
show("Integer(BadStrConv)")   { try { Integer(BadStrConv.new) } }
show("Integer(StrAndToI)")    { try { Integer(StrAndToI.new) } }
show("Integer(WrongStrConv)") { try { Integer(WrongStrConv.new) } }
show("Integer(Plain)")        { try { Integer(Plain.new) } }

puts "--- exception: false"
show("Integer(IntAnswer, exception: false)")   { try { Integer(IntAnswer.new, exception: false) } }
show("Integer(BigAnswer, exception: false)")   { try { Integer(BigAnswer.new, exception: false) } }
show("Integer(StrAnswer, exception: false)")   { try { Integer(StrAnswer.new, exception: false) } }
show("Integer(RaisesToInt, exception: false)") { try { Integer(RaisesToInt.new, exception: false) } }
show("Integer(RaiseThenToI, exception: false)") { try { Integer(RaiseThenToI.new, exception: false) } }
show("Integer(ToIString, exception: false)")   { try { Integer(ToIString.new, exception: false) } }
show("Integer(ToIRaises, exception: false)")   { try { Integer(ToIRaises.new, exception: false) } }
show("Integer(StrConv, exception: false)")     { try { Integer(StrConv.new, exception: false) } }
show("Integer(BadStrConv, exception: false)")  { try { Integer(BadStrConv.new, exception: false) } }
show("Integer(Plain, exception: false)")       { try { Integer(Plain.new, exception: false) } }

puts "--- with a base"
show("Integer(StrConv, 16)")                    { try { Integer(StrConv.new, 16) } }
show("Integer(StrConv, 10, exception: false)")  { try { Integer(StrConv.new, 10, exception: false) } }
show("Integer(IntAnswer, 16)")                  { try { Integer(IntAnswer.new, 16) } }
show("Integer(IntAnswer, 16, exception: false)") { try { Integer(IntAnswer.new, 16, exception: false) } }
show("Integer(Plain, 10)")                      { try { Integer(Plain.new, 10) } }

puts "--- Float"
class FltAnswer;   def to_f; note(:to_f); 2.5; end; end
class FltIntAnswer; def to_f; note(:to_f); 3; end; end
class FltStrAnswer; def to_f; note(:to_f); "2.5"; end; end
class FltNilAnswer; def to_f; note(:to_f); nil; end; end
class FltRaises;   def to_f; note(:to_f); raise "boom"; end; end
class FltStrOnly;  def to_str; note(:to_str); "2.5"; end; end
class FltIntOnly;  def to_int; note(:to_int); 4; end; end

show("Float(FltAnswer)")     { try { Float(FltAnswer.new) } }
show("Float(FltIntAnswer)")  { try { Float(FltIntAnswer.new) } }
show("Float(FltStrAnswer)")  { try { Float(FltStrAnswer.new) } }
show("Float(FltNilAnswer)")  { try { Float(FltNilAnswer.new) } }
show("Float(FltRaises)")     { try { Float(FltRaises.new) } }
show("Float(FltStrOnly)")    { try { Float(FltStrOnly.new) } }
show("Float(FltIntOnly)")    { try { Float(FltIntOnly.new) } }
show("Float(Plain)")         { try { Float(Plain.new) } }
show("Float(FltAnswer, exception: false)")    { try { Float(FltAnswer.new, exception: false) } }
show("Float(FltIntAnswer, exception: false)") { try { Float(FltIntAnswer.new, exception: false) } }
show("Float(FltRaises, exception: false)")    { try { Float(FltRaises.new, exception: false) } }
show("Float(Plain, exception: false)")        { try { Float(Plain.new, exception: false) } }

puts "--- through a container"
mixed = [IntAnswer.new, StrConv.new, Plain.new, "42", 9, 2.75, nil, FltAnswer.new]
mixed.each_with_index do |x, i|
  show("Integer(mixed[#{i}])")                  { try { Integer(x) } }
  show("Integer(mixed[#{i}], exception: false)") { try { Integer(x, exception: false) } }
  show("Float(mixed[#{i}], exception: false)")  { try { Float(x, exception: false) } }
end
show("Integer(mixed[1], 16)") { try { Integer(mixed[1], 16) } }
show("Integer(mixed[3], 16)") { try { Integer(mixed[3], 16) } }
show("Integer(mixed[4], 16)") { try { Integer(mixed[4], 16) } }
show("Integer(mixed[4], 16, exception: false)") { try { Integer(mixed[4], 16, exception: false) } }

puts "--- the answer is carried"
big = Integer(BigAnswer.new)
p big + 1
p big.class
p Integer(IntAnswer.new) + 1
p Float(FltAnswer.new) * 2
