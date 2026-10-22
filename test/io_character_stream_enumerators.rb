# spinel: gc-stress
# IO#each_char and #each_codepoint without a block answer an Enumerator
# that reads the stream only when it is pulled.
require "tmpdir"

r, w = IO.pipe
w.write("éx")
w.close
p r.each_char.to_a
r.close

r, w = IO.pipe
e = r.each_codepoint
p [e.class, e.size]
w.write("éx")
w.close
p e.to_a
r.close

# a pipe's Enumerator inspects with its descriptor
r, w = IO.pipe
puts r.each_char.inspect.sub(/fd \d+/, "fd N")
w.close
r.close

path = File.join(Dir.tmpdir, "spinel-each-char-#{Process.pid}")
File.write(path, "ab\ncd\n")
begin
  File.open(path) do |f|
    e = f.each_char
    puts e.inspect.sub(path, "PATH")
    # the Enumerator shares the File's position with gets
    p e.next
    p f.gets
    p e.next
    # each and with_index with a block answer the File
    seen = []
    p e.each { |c| seen << c }.equal?(f)
    p seen
    f.rewind
    p e.with_index { |c, i| seen << i }.equal?(f)
    # rewind rewinds the File
    f.rewind
    c = f.each_codepoint
    p c.next
    p c.next
    c.rewind
    p f.pos
    p c.next
  end
ensure
  File.delete(path)
end
