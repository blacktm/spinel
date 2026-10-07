# Narrow String#to_i results exceeding int64 retain a loud RangeError.
# Kernel Integer carries the full Bignum result in every overflow mode.

begin
  "99999999999999999999".to_i
  puts "no exception"
rescue RangeError
  puts "to_i raised RangeError"
end

begin
  "ffffffffffffffff0".to_i(16)
  puts "no exception"
rescue RangeError
  puts "to_i(16) raised RangeError"
end

puts Integer("99999999999999999999")

# In-range values still work.
puts "42".to_i
puts "ff".to_i(16)
puts Integer("-1000")
