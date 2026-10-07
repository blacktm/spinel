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

# a class method of the name, on a Class in the slot, is still the one called
class Notifier
  def self.signal; :class_signal; end
end
p [Notifier, cv].map { |v| v.signal.equal?(cv) ? :cv : v.signal }
# a boxed value that is not a ConditionVariable raises as CRuby does
begin
  [Mutex.new, 5][1].signal
rescue NoMethodError => e
  p [e.message, e.args]
end
