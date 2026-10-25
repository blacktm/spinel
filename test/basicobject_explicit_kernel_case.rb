# Blank slates at depth, ::BasicObject superclass, blank slate including Kernel
class A < BasicObject; end
class B < A; end
class C < B; end
class D < ::BasicObject; end
class E < D; end
class K < BasicObject
  include ::Kernel
end
c = C.new
e = E.new
k = K.new
puts(case c; in Object then "c-object"; else "c-other"; end)
puts(case c; when Kernel then "c-kernel"; else "c-other"; end)
puts(case c; in BasicObject then "c-basic"; else "c-other"; end)
puts(case c; in A then "c-A"; else "c-other"; end)
puts(case e; in Object then "e-object"; else "e-other"; end)
puts(case e; when Kernel then "e-kernel"; else "e-other"; end)
puts(case e; in BasicObject then "e-basic"; else "e-other"; end)
puts(case k; in Kernel then "k-kernel"; else "k-other"; end)
puts(case k; when Kernel then "k-w-kernel"; else "k-other"; end)
puts(case k; in Object then "k-object"; else "k-other"; end)
class L < K; end
l = L.new
puts(case l; when Kernel then "l-kernel"; else "l-other"; end)
puts(case l; when Object then "l-object"; else "l-other"; end)
def mk(i) = i == 0 ? K.new : nil
puts(case mk(0); when Kernel then "x-kernel"; else "x-other"; end)
puts(case mk(1); when Kernel then "x-kernel"; else "x-other"; end)
v = case k
    when Integer then "int"
    when Kernel then "kernel"
    end
puts v
puts(case k; in Kernel => kk then "bound"; else "no"; end)
