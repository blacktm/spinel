# spinel: share
# spinel: gc-stress
r,w=IO.pipe
p [w.binmode.equal?(w),w.binmode?,w.external_encoding]
w.close;r.close
