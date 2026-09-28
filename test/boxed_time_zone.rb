# inspect, to_s, puts and interpolation of a Time read out of a container
# render it in its own zone, as a typed Time does, where they rendered it
# in UTC.
t = Time.new(2000, 1, 2, 12, 30, 0, "+09:00")
x = [t, 0][0]
p x
puts x
puts "at #{x}"
p x.to_s
p [Time.new(2000, 1, 2, 12, 30, 0, "-05:30"), 0][0]
p [Time.at(1.5).utc, 0][0]
p [x, 1]
p [Time.at(0).utc, 0][0]
l = Time.at(0)
p [l, 0][0].inspect == l.inspect
