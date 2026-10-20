# A blockless IO Enumerator stored, read out of an Array or Hash, passed,
# returned, aliased or held in an ivar walks the stream as CRuby does.
require "tmpdir"

r, w = IO.pipe; w.write("a\nb\nc\n"); w.close
e = r.each_line
p e.next, e.peek, e.next
p e.with_index.to_a
r.close

r, w = IO.pipe; w.write("a\nb\nc\n"); w.close
e = r.each_line
p r.gets
p e.to_a
r.close

r, w = IO.pipe; w.write("x\ny\n"); w.close
a = [r.each_line, 0]
p a[0].to_a
r.close

def walk(en) = en.map(&:chomp)
r, w = IO.pipe; w.write("x\ny\n"); w.close
p walk(r.each_line)
r.close

def mk(io) = io.each_byte
r, w = IO.pipe; w.write("hi"); w.close
e = mk(r)
p e.to_a
r.close

r, w = IO.pipe; w.write("1\n2\n3\n"); w.close
e = r.each_line; g = e
p e.next; p g.next
r.close

class H
  def initialize(io) = @e = io.each_char
  def all = @e.to_a
end
r, w = IO.pipe; w.write("ab"); w.close
p H.new(r).all
r.close

r, w = IO.pipe; w.write("a\nbb\nccc\n"); w.close
p r.each_line.lazy.map(&:chomp).select { |s| s.size > 1 }.first(1)
r.close

r, w = IO.pipe; w.write("q\n"); w.close
h = {k: r.each_line}
p h[:k].next
r.close

r, w = IO.pipe; w.write("a\nb\n"); w.close
e = r.each_line
e = [1, 2].each if false
p e.to_a
r.close

r, w = IO.pipe; w.write("a\nb\n"); w.close
e = r.each_line
e.each_with_index { |l, i| p [l, i] }
r.close

path = File.join(Dir.tmpdir, "spinel_io_enum_rw_#{$$}.txt")
File.write(path, "a\nb\n")
f = File.open(path)
e = f.each_line
p e.next
e.rewind
p e.next
f.close
File.delete(path)

path = File.join(Dir.tmpdir, "spinel_io_enum_f_#{$$}.txt")
File.write(path, "éx\n")
File.open(path) do |f|
  p f.each_codepoint.to_a
end
File.open(path) { |f| p f.each_char.to_a }
File.open(path) { |f| p f.each.to_a }
File.delete(path)
