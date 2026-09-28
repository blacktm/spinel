# Pathname#truncate cuts the file to the length given, as File.truncate does.
require "pathname"
path = "pathname_truncate_#{Process.pid}.txt"
File.write(path, "abcdef")
pn = Pathname.new(path)
p pn.truncate(2)
p File.read(path)
p pn.truncate(0)
p pn.size
begin
  Pathname.new("no_such_dir_#{Process.pid}/x").truncate(1)
rescue SystemCallError => e
  p e.class
end
File.delete(path)
