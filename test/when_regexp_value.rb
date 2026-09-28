# `when` with a Regexp that a call or a variable answers matches a String,
# a Symbol or a boxed subject by Regexp#===, as a literal Regexp does.
def pat = /b/
def re_for(k) = k == :x ? /x/ : /y/
p(case "abc"; when pat then :re; else :no; end)
p(case "xyz"; when re_for(:x) then :re; else :no; end)
p(case "abc"; when re_for(:z) then :re; else :no; end)
s = ["abc", 1][0]
p(case s; when pat then :re; else :no; end)
p(case :cab; when pat then :sym; else :no; end)
re = Regexp.new("c$")
case "abc"
when re then p :stmt
else p :no
end
case [5, "s"][0]
when re then p :stmt
else p :no
end
# an interpolated Regexp, and a Regexp-typed arm that is nil
side = "c"
p(case "abc"; when /#{side}$/ then :interp; else :no; end)
class Holder
  def initialize(set) = (@re = /b/ if set)
  def test(s) = (case s; when @re then :re; else :no; end)
end
p Holder.new(false).test("abc")
p Holder.new(true).test("abc")
def arm(v, re = nil) = (case v; when re then :hit; else :no; end)
p arm("abc", /b/)
p arm("abc")
p arm([nil, 1][0])
