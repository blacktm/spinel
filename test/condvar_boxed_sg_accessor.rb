# A boxed ConditionVariable takes signal and broadcast in a program whose
# Class in the same slot has a singleton-class accessor of the name: the
# class-value dispatch keeps the accessor, and its non-Class side reaches
# the ConditionVariable's own signal.
class Signaller
  class << self
    attr_accessor :signal
  end
end
Signaller.signal = 5
scv = ConditionVariable.new
[Signaller, scv].each { |v| r = v.signal; p(r.equal?(scv) ? :cv : r) }
[Signaller, scv, 7].each do |v|
  r = v.signal
  p(r.equal?(scv) ? :cv : r)
rescue NoMethodError => e
  p e.message
end
