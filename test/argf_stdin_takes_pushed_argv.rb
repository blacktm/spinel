# ARGF reading the default stdin moves to a file pushed onto ARGV, as CRuby
# does, and reads that file next.
path = "/tmp/spinel_argf_push_#{Process.pid}"
File.write(path, "x1\nx2\n")
p ARGF.gets
ARGV << path
p ARGF.gets
p ARGF.filename == path
p ARGF.gets
p ARGF.gets
File.delete(path)
