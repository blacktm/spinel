# A Dir read out of a container enumerates its entries, dots included, as a
# typed Dir does: to_a, select, reject, sort, sort_by, take, drop, each_slice.
path = "/tmp/sp_boxed_dir_entries"
Dir.mkdir(path) unless Dir.exist?(path)
File.write("#{path}/a", "")
File.write("#{path}/b", "")

h = Dir.open(path); d = [h, 0][0]
p d.to_a.sort
h.close
h = Dir.open(path); d = [h, 0][0]
p d.select { |e| e == "a" }
h.close
h = Dir.open(path); d = [h, 0][0]
p d.reject { |e| e.start_with?(".") }.sort
h.close
h = Dir.open(path); d = [h, 0][0]
p d.sort
h.close
h = Dir.open(path); d = [h, 0][0]
p d.sort_by { |e| e.length }.length
h.close
h = Dir.open(path); d = [h, 0][0]
p [d.to_a.length, d.to_a.length]
h.close
h = Dir.open(path); d = [h, 0][0]
p [d.take(3).length, d.drop(3).length, d.each_slice(3).to_a.length]
h.close

File.delete("#{path}/a", "#{path}/b")
Dir.rmdir(path)
