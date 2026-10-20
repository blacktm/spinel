# Fiber#raise(nil) and Thread#raise(nil) are TypeError "exception
# class/object expected", raised in the caller (a fiber in any state; a
# thread unless it is dead, where the raise does nothing): unborn, suspended or finished, a nil
# literal, a nil read out of an Array or a method that answers nil
def t(label)
  p yield
rescue TypeError, FiberError => e
  puts "#{label}: #{e.class}: #{e.message}"
end
t("unborn") { Fiber.new { 1 }.raise(nil) }
g = Fiber.new { Fiber.yield 1; 2 }
g.resume
t("suspended") { g.raise(nil) }
done = Fiber.new { 1 }
done.resume
t("finished") { done.raise(nil) }
n = [nil, 1][0]
t("boxed nil") { Fiber.new { 1 }.raise(n) }
def maybe(x) = x > 0 ? RuntimeError : nil
t("nullable nil") { Fiber.new { 1 }.raise(maybe(-1)) }
t("no argument") { Fiber.new { 1 }.raise }
q = Queue.new
th = Thread.new { q.pop; :done }
t("thread") { th.raise(nil) }
t("thread boxed nil") { th.raise(n) }
q << 1
p th.value
t("dead thread") { th.raise(nil) }
