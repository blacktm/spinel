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

c.close
d.close
a.close
a2.close

puts "done"
