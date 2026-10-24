# spinel: gc-stress
# A Dir read back out of a container answers Enumerable's walks over its
# entries, children and each_child without "." and "..", and none of
# Array's own methods.
require "tmpdir"
path = "#{Dir.tmpdir}/spinel-boxed-dir-catalog-#{Process.pid}"
Dir.mkdir(path)
File.write("#{path}/a", "")
File.write("#{path}/b", "")
[:children, :entries, :to_a, :each_child, :select, :map, :reject, :sort,
 :collect, :filter, :inject, :uniq, :zip, :read_after_children, :entries_after_read,
 :each_child_inspect, :flatten, :last, :values_at, :join].each do |name|
  d = Dir.open(path)
  x = [d, 0][0]
  begin
    value = case name
            when :children then x.children.sort
            when :entries then x.entries.sort
            when :to_a then x.to_a.sort
            when :each_child then x.each_child.to_a.sort
            when :select then x.select { |e| e == "a" }
            when :map then x.map { |e| e.upcase }.sort
            when :reject then x.reject { |e| e == "a" }.sort
            when :sort then x.sort
            when :collect then x.collect { |e| e + "!" }.sort
            when :filter then x.filter { |e| e == "b" }
            when :inject then x.inject(0) { |s, e| s + e.size }
            when :uniq then x.uniq.size
            when :zip then x.zip([1, 2, 3, 4]).size
            when :read_after_children then x.children; x.read
            when :entries_after_read then x.read; x.entries.size
            when :each_child_inspect then x.each_child.inspect.sub(path, "P")
            when :flatten then x.flatten
            when :last then x.last
            when :values_at then x.values_at(0)
            when :join then x.join(",")
            end
    p [name, value]
  rescue => error
    p [name, error.class]
  ensure
    d.close rescue nil
  end
end
File.delete("#{path}/a", "#{path}/b")
Dir.rmdir(path)
