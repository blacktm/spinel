# spinel: gc-stress
require "socket"
require "tmpdir"
r, w = IO.pipe
begin
  p [r.path, r.to_path, w.path, w.to_path]
  p r.path.nil?
  p(r.path || "none")
  boxed = [r, 1][0]
  p [boxed.path, boxed.to_path]
  w.write("x")
  r.read(1)
  p r.path
  # a nil path reaching File's path functions raises, as in CRuby
  begin
    File.basename(r.path)
  rescue TypeError => e
    p [:basename, e.message]
  end
  begin
    File.dirname(r.path)
  rescue TypeError => e
    p [:dirname, e.message]
  end
  begin
    File.extname(r.path)
  rescue TypeError => e
    p [:extname, e.message]
  end
  begin
    File.split(r.path)
  rescue TypeError => e
    p [:split, e.message]
  end
ensure
  r.close
  w.close
end
p [$stdout.path, $stdin.path]
name = "#{Dir.tmpdir}/sp_iop_#{Process.pid}"
begin
  f = File.open(name, "w")
  p [f.path == name, f.to_path == name]
  f.close
  p f.path == name
ensure
  File.delete(name) if File.exist?(name)
end
# a UNIX-domain socket with no address answers "", not nil
sock = "#{Dir.tmpdir}/sp_iop_#{Process.pid}.sock"
begin
  server = UNIXServer.new(sock)
  client = UNIXSocket.new(sock)
  p client.path
  p [client, 1][0].path
  client.close
  server.close
ensure
  File.delete(sock) if File.exist?(sock)
end
