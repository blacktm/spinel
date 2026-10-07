m = [Mutex.new, 0][0]

[:lock, :try_lock, :locked?, :owned?].each do |name|
  begin
    value = case name
    when :lock
      result = m.lock
      m.unlock
      result
    when :try_lock
      result = m.try_lock
      m.unlock if result
      result
    when :locked? then m.locked?
    when :owned? then m.owned?
    end
    p [name, value.class, name == :lock ? value.equal?(m) : value]
  rescue => error
    p [name, error.class, error.message]
  end
end

p [m.lock.equal?(m), m.locked?, m.owned?, m.try_lock]
p m.unlock.equal?(m)
p [m.locked?, m.owned?]
class Custom
  def lock; :custom; end
  def owned?; :custom; end
end
[Custom.new, m].each do |value|
  result = value.lock
  p [result.class, value.owned?]
end
m.unlock
# owned? is File::Stat's too: a boxed stat answers it beside the Mutex and
# the user class above.
require "tmpdir"
path = File.join(Dir.tmpdir, "spinel_mutex_boxed_controls_#{Process.pid}")
File.write(path, "x")
[[File.stat(path), 0][0], m].each { |value| p value.owned? }
File.delete(path)
