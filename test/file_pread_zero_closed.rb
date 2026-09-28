# pread with a zero length answers "" before the stream is checked, on a
# closed File too, as CRuby does; a nonzero length still raises IOError.
path = "/tmp/spinel_pread_closed_#{Process.pid}"
File.write(path, "abcdef")
f = File.open(path)
p f.pread(2, 1)
p f.pread(0, 3)
f.close
p (f.pread(0, 1) rescue [$!.class, $!.message])
p (f.pread(2, 0) rescue [$!.class, $!.message])
File.delete(path)
