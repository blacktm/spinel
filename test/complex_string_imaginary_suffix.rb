# Kernel#Complex and String#to_c share Ruby's imaginary-unit suffixes.
p Complex("1+2j")
["i", "I", "j", "J", "+j", "-j", "+J", "-J",
 "2j", "-2J", "1+j", "1-J", "1+2J", "1-2j",
 "1.25+2.5j", " 1+2j "].each do |input|
  p Complex(input)
  p input.to_c
end
# The lenient parser consumes an imaginary suffix before ignoring the tail.
p "1+2jtail".to_c
p "-Jtail".to_c
# Strict parsing must still reject a second suffix or trailing junk.
["1+2jj", "jJ", "1+2Jtail", "1+2k"].each do |input|
  p Complex(input, exception: false)
  begin
    Complex(input)
  rescue ArgumentError
    puts "invalid suffix rejected"
  end
end
# Runtime String buffers, a method argument, and GC use the same parser.
def parse_suffix(input)
  GC.start
  Complex(input)
end
input = +"3"
input << "+4j"
p parse_suffix(input)
p input.to_c
