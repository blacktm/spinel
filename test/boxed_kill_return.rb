# Thread#kill, and Fiber#kill on a fiber not killed before, answer the
# receiver, also through a boxed value such as the element of a mixed Array.
[:alive?, :kill, :raise].each do |name|
  f = [Fiber.new { Fiber.yield 1 }, 0][0]
  begin
    value = case name
    when :alive? then f.alive?
    when :kill
      f.resume
      f.kill.is_a?(Fiber)
    when :raise
      f.resume
      f.raise("boom")
    end
    p [name, value.class, value]
  rescue => error
    p [name, error.class, error.message]
  end
end

f = [Fiber.new do
  begin
    Fiber.yield :ready
  ensure
    puts "ensure"
  end
end, 0][0]
p f.resume
result = f.kill
p [result.equal?(f), result.is_a?(Fiber), f.alive?]
u = [Fiber.new { puts "unstarted body" }, 0][0]
p [u.kill.equal?(u), u.alive?]

t = [Thread.new { sleep }, 0][0]
p t.alive?
result = t.kill
p [result.class, result.equal?(t)]
t.join
p t.alive?

class Custom
  def kill; :custom; end
end
[Custom.new, Fiber.new { Fiber.yield }, Thread.new { sleep }].each { |value| p value.kill.class }
