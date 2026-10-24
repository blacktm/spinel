# spinel: gc-stress
# ARGF and direct stdin reads share the stream $stdin holds: a StringIO,
# then a File, each read in turn by ARGF.gets and $stdin.gets.
require "stringio"
require "tmpdir"
path = File.join(Dir.tmpdir, "spinel-argf-stdin-#{Process.pid}.txt")
raise "temporary path already exists" if File.exist?(path)
original = $stdin
input = nil
begin
  $stdin = StringIO.new("s1\ns2\n")
  p ARGF.gets
  p $stdin.gets
  File.write(path, "f1\nf2\n")
  input = File.open(path)
  $stdin = input
  p ARGF.gets
  p $stdin.gets
  p ARGF.gets
ensure
  $stdin = original
  input.close if input
  File.delete(path) if File.exist?(path)
end
