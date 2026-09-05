# A filesystem call that fails raises the Errno exception CRuby raises, with
# CRuby's message, instead of answering -1, 0, nil or a success count:
# Dir.mkdir / rmdir / delete / unlink / chdir, File.delete / unlink / rename /
# truncate, and the Pathname methods built on them. The metadata readers
# (File.size, atime, mtime, ctime, birthtime) name CRuby's entry point in
# their message too.

require "pathname"

def try(label)
  r = yield
  puts "#{label} => #{r.inspect}"
rescue SystemCallError => e
  puts "#{label}: #{e.class}: #{e.message}"
end

base = "/tmp/sp_syscall_errno"
Dir.mkdir(base) unless Dir.exist?(base)
missing = "#{base}/missing"
file = "#{base}/file.txt"
File.write(file, "abc")
sub = "#{base}/sub"
Dir.mkdir(sub) unless Dir.exist?(sub)
File.write("#{sub}/inner", "")

puts "--- Dir"
try("mkdir existing") { Dir.mkdir(base) }
try("mkdir under a missing parent") { Dir.mkdir("#{missing}/child") }
try("mkdir") { Dir.mkdir("#{base}/fresh") }
try("rmdir") { Dir.rmdir("#{base}/fresh") }
try("rmdir missing") { Dir.rmdir(missing) }
try("rmdir non-empty") { Dir.rmdir(sub) }
try("rmdir a file") { Dir.rmdir(file) }
try("delete missing") { Dir.delete(missing) }
try("unlink missing") { Dir.unlink(missing) }
try("chdir missing") { Dir.chdir(missing) }
try("chdir a file") { Dir.chdir(file) }

puts "--- File"
try("delete missing") { File.delete(missing) }
try("unlink missing") { File.unlink(missing) }
try("delete") { File.delete(file) }
try("delete two, second missing") { File.write(file, "abc"); File.delete(file, missing) }
try("deleted the first before raising") { File.exist?(file) }
try("rename missing") { File.rename(missing, file) }
try("rename into a missing directory") { File.write(file, "abc"); File.rename(file, "#{missing}/x") }
try("rename") { File.rename(file, "#{file}.moved") }
try("rename back") { File.rename("#{file}.moved", file) }
try("truncate negative") { File.truncate(file, -1) }
try("truncate missing") { File.truncate(missing, 0) }
try("truncate") { File.truncate(file, 1) }
try("size missing") { File.size(missing) }
try("atime missing") { File.atime(missing) }
try("mtime missing") { File.mtime(missing) }
try("ctime missing") { File.ctime(missing) }
try("birthtime missing") { File.birthtime(missing) }

puts "--- rescue shapes"
begin
  Dir.rmdir(missing)
rescue Errno::ENOENT => e
  puts "Errno::ENOENT caught: #{e.message}"
end
begin
  File.delete(missing)
rescue => e
  puts [e.is_a?(SystemCallError), e.is_a?(StandardError), e.class].inspect
end
result = begin
  Dir.mkdir(base)
rescue Errno::EEXIST
  :already_there
end
p result

puts "--- Pathname"
pn = Pathname.new(missing)
try("rmdir") { pn.rmdir }
try("delete") { pn.delete }
try("unlink") { pn.unlink }
try("rename") { pn.rename("#{base}/elsewhere") }
try("size") { pn.size }
try("mkdir existing") { Pathname.new(sub).mkdir }
try("mkdir") { Pathname.new("#{base}/made").mkdir }
try("rmdir made") { Pathname.new("#{base}/made").rmdir }

File.delete("#{sub}/inner")
Dir.rmdir(sub)
File.delete(file)
Dir.rmdir(base)
p Dir.exist?(base)
