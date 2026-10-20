# spinel: share
# spinel: gc-stress
# Blockless IO#each_line, #each, #each_byte, #each_char and #each_codepoint answer
# Enumerators that read the stream as they walk.
require "tmpdir"
r, w = IO.pipe
w.write("a\nb\n")
w.close
p r.each_line.to_a
r.close
r,w=IO.pipe
e=r.each_byte
p [e.class,e.size]
w.write("ab");w.close
p e.to_a
r.close

r,w=IO.pipe;w.write("a\nb\n");w.close
e=r.each_line
p [e.class,e.size,e.peek,e.peek,e.next,e.next]
2.times do
 begin;e.next;rescue StopIteration=>s;p [s.class,s.result.equal?(r)];end
end
r.close

r,w=IO.pipe;w.write("a\nb\nc\n");w.close
e=r.each_line
p r.gets;p e.next;p e.to_a
begin;e.next;rescue StopIteration=>s;p s.result.equal?(r);end
r.close

r,w=IO.pipe;e=r.each_line;r.close;w.close
p [e.class,e.size]
begin;e.next;rescue=>s;p [s.class,s.message];end
r,w=IO.pipe;r.close;w.close;e=r.each_byte
p e.class
begin;e.to_a;rescue=>s;p [s.class,s.message];end

r,w=IO.pipe;w.write("\x00A\xFF".b);w.close
p r.each_byte.to_a;r.close
r,w=IO.pipe;w.write("a\x00b\n");w.close
p r.each_line.to_a;r.close

r,w=IO.pipe;w.write("a\nb\n");w.close
e=r.each
p e.to_a;p e.to_a
r.close

r,w=IO.pipe;w.write("é\n");w.close
p r.each_char.to_a;r.close
r,w=IO.pipe;w.write("é\n");w.close
p r.each_codepoint.to_a;r.close

r,w=IO.pipe;w.write("a\nb\n");w.close
e=r.each_line
p e.with_index.to_a
p e.with_index{|v,i|}.equal?(r)
p e.each{|v|}.equal?(r)
r.close

r,w=IO.pipe;w.write("a\n");w.close
e=r.each_line;p e.next
begin;e.rewind;rescue=>s;p [s.class,s.message];end
r.close

Dir.mktmpdir do |d|
 path=File.join(d,"input");File.write(path,"a\nb\n")
 f=File.open(path);e=f.each_line
 p e.next;p f.lineno;p e.rewind.equal?(e);p f.lineno;p e.next
 f.close
end

def reader(path);File.open(path).each_line;end
Dir.mktmpdir do |d|
 path=File.join(d,"input");File.write(path,"a\nb\n")
 e=reader(path);GC.start
 a=e.next;GC.start;p a;p e.next
 begin;e.next;rescue StopIteration=>s;p s.result.class;s.result.close;end
end

# a File::Stat has no stream: its blockless each_* is NoMethodError
Dir.mktmpdir do |d|
 path=File.join(d,"input");File.write(path,"ab")
 s=File.stat(path)
 begin;s.each_byte;rescue NoMethodError=>x;p x.message;end
 begin;File.lstat(path).each_line;rescue NoMethodError=>x;p x.message;end
end
