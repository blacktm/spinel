# `Klass === obj` with a builtin class and a user object answers as
# obj.is_a?(Klass) does, as in CRuby, where it raised NoMethodError: a user
# exception by its class chain, any other builtin class false.
class MyErr < StandardError; end
class Plain; end
e = MyErr.new("x")
p StandardError === e
p Exception === e
p RuntimeError === e
p MyErr === e
p String === Plain.new
p Integer === Plain.new
p Plain === Plain.new
