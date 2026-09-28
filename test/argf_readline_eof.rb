# ARGF.readline answers the next line, as ARGF.gets does, and raises
# EOFError at the end of the input, where ARGF.gets answers nil; with
# chomp: true it raises the same way. On 62f376e7 each readline past the
# last line answered nil.
p ARGF.readline
p ARGF.readline(chomp: true)
p ARGF.gets
p ARGF.gets
begin
  p ARGF.readline
rescue EOFError => e
  puts e.class
  puts e.message
end
begin
  p ARGF.readline(chomp: true)
rescue EOFError => e
  puts e.class
end
begin
  p ARGF.readline
rescue IOError => e
  puts e.class
end
puts "done"
