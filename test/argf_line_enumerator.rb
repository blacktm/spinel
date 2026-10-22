# spinel: gc-stress
# ARGF.lineno counts the lines read across ARGF's files, and ARGF.each_line
# and ARGF.each without a block answer an Enumerator that reads ARGF's one
# cursor only when it is driven.
p [ARGF.class, ARGF.filename, ARGF.lineno]
p ARGF.each_line.class
require "tmpdir"
input = File.join(Dir.tmpdir, "spinel_argf_line_enumerator_#{Process.pid}.txt")
File.write(input, "hello\nworld\nfin\n")
ARGV << input << input
e = ARGF.each_line
p [e.size, ARGF.lineno, ARGV.size]
p e.next
p ARGF.lineno
p ARGF.gets
p ARGF.lineno
e.rewind
p [ARGF.lineno, e.next]
p ARGF.each.next
p ARGF.readline
p ARGF.lineno
p ARGF.read
p ARGF.lineno
begin
  e.next
rescue StopIteration => stop
  p stop.result.equal?(ARGF)
end
File.delete(input)
