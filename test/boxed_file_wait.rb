# wait_readable and wait_priority on an IO handle read out of a container
# (a File, a pipe reader) answer the handle once it is ready and nil when
# the timeout runs out, as on a typed File.
path = "/tmp/sp_boxed_file_wait.txt"
File.write(path, "x")
def m(f) = f.wait_readable(0)
def fresh(path) = [File.open(path), 0][0]

f = [File.open(path), 0][0]
v = f.wait_readable(0); p [v.class, v.equal?(f)]
v = f.wait_readable; p [v.class, v.equal?(f)]
v = f.wait_readable(nil); p [v.class, v.equal?(f)]
v = f.wait_readable(0.5); p [v.class, v.equal?(f)]
v = f.wait_priority(0); p [v.class, v.equal?(f)]
v = f.wait_priority; p [v.class, v.equal?(f)]
p [f.wait_readable(0).class, m(f).equal?(f)]
t = [nil, 1][0]
p [f.wait_readable(1/2r).class, f.wait_readable(t).class]
puts(f.wait_readable(0) ? "ready" : "not ready")
e = (f.wait_readable(1, 2) rescue $!)
p [e.class, e.message]
e = (f.wait_readable("1") rescue $!)
p [e.class, e.message]
st = [File.stat(path), 0][0]
e = (st.wait_readable(0) rescue $!)
p e.class
e = (st.wait_readable(0, 1) rescue $!)
p e.class
f.close
e = (f.wait_readable(0) rescue $!)
p [e.class, e.message]

# a receiver that is no IO raises after its argument is evaluated
x = [5, "s"][0]
e = (x.wait_readable((puts "argument"; 0)) rescue $!)
p e.class

# the handle a call answers, held nowhere else, across a timeout that
# allocates
n = 0
i = 0
while i < 100
  n += 1 if fresh(path).wait_readable((("r" * 3000).clear; 0))
  i += 1
end
p n

r, w = IO.pipe
x = [r, 0][0]
p x.wait_readable(0)
p x.wait_priority(0)
t = 0.01
puts "not ready" unless x.wait_readable(t)
w.write("a")
p x.wait_readable(0).equal?(r)
r.close
w.close
File.delete(path)
