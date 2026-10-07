native = ConditionVariable.new
cv = [native, 0][0]
p [cv.signal.equal?(cv), cv.broadcast.equal?(cv), cv.class]
class Custom
  def signal; :signal; end
  def broadcast; :broadcast; end
end
[Custom.new, cv].each do |value|
  signaled = value.signal
  broadcast = value.broadcast
  p [signaled.class, broadcast.class, signaled.equal?(value), broadcast.equal?(value)]
end
m = Mutex.new
ready = Queue.new
worker = Thread.new do
  m.synchronize do
    ready << :waiting
    native.wait(m)
    7
  end
end
ready.pop
m.synchronize { cv.signal }
p worker.value
workers = []
2.times do
  workers << Thread.new do
    m.synchronize do
      ready << :waiting
      native.wait(m)
      9
    end
  end
end
2.times { ready.pop }
m.synchronize { cv.broadcast }
p workers.map { |thread| thread.value }
