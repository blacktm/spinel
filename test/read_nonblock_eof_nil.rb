# read_nonblock with `exception: false` distinguishes EOF from would-block.
# At EOF, the call returns nil (CRuby's nil, not :wait_readable). When the
# fd is not readable yet, the call returns :wait_readable. Without the
# keyword, EOF raises EOFError as before.
#
# Spinel's sp_sock_read_nb used to fold both EOF and would-block into the
# same NULL return; the codegen then mapped NULL to :wait_readable, which
# turned every IO.select + read_nonblock loop into a busy spin because
# select said readable and read said would block. The fix adds an
# out-parameter so the codegen can tell EOF from would-block.

require "socket"

a, b = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)

# 1. exception: false at EOF -> nil
b.write "x"
b.close
p a.read_nonblock(64, exception: false)      #=> "x"
p a.read_nonblock(64, exception: false)      #=> nil

# 2. exception: false when would block -> :wait_readable
c, d = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)
p c.read_nonblock(64, exception: false)      #=> :wait_readable

# 3. raising form at EOF -> EOFError
a2, b2 = Socket.pair(Socket::AF_UNIX, Socket::SOCK_STREAM, 0)
b2.close
begin
  a2.read_nonblock(64)
  p "no error"                                # NOT this
rescue EOFError
  p "EOFError"
end

# 4. recv_nonblock is NOT read_nonblock at EOF: CRuby answers "" for it in
#    BOTH forms -- it neither answers nil nor raises EOFError. It reaches a
#    different emitter (a TY_IO receiver), which is why it takes a socket
#    made this way rather than one from Socket.pair.
srv = TCPServer.new("127.0.0.1", 0)
port = srv.addr[1]
t = Thread.new do
  cs = TCPSocket.new("127.0.0.1", port)
  cs.write("y")
  cs.close
end
s1 = srv.accept
sleep 0.2
p s1.recv_nonblock(64, exception: false)     #=> "y"
p s1.recv_nonblock(64, exception: false)     #=> "" (not nil, not :wait_readable)
p s1.recv_nonblock(64)                       #=> "" (the raising form does not raise here)
t.join
s1.close
srv.close

c.close
d.close
a.close
a2.close

puts "done"
