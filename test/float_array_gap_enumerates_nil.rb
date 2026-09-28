# A Float Array with a gap filled by assigning past its end enumerates the
# gap as nil through its enumerators, as printing the Array shows it, not as
# NaN.
fl = [1.5]
fl[3] = 2.5
p fl
p fl.reverse_each.to_a
p fl.each.to_a
p fl.each_slice(2).to_a
p fl.each.with_index.to_a.size
p fl.each_slice(3).map(&:size)
p fl.count(&:nil?)
