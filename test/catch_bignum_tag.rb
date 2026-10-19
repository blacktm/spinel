# spinel: int64 -- Bignum tags (10**30)
# Bignum tags use object identity, including across boxed/native paths.
tag = 10**30
p catch(tag) { throw(tag, 1) }

negative = -(10**30)
p catch(negative) { GC.start; throw(negative, 2) }

items = [tag, :other]
p catch(items[0]) { GC.start; throw(tag, 3) }
p catch(tag) { GC.start; throw(items[0], 4) }

# Compute an equal-valued separate object without reusing a folded literal.
offset = ARGV.length + 1
other = (tag + offset) - offset
p tag == other
begin
  catch(tag) { throw(other, 5) }
rescue UncaughtThrowError
  puts "distinct tag rejected"
end

# An inner catch for another Bignum must let the outer matching tag receive it.
p catch(tag) {
  catch(negative) {
    begin
      GC.start
      throw(tag, 6)
    ensure
      puts "ensure"
    end
  }
}
p catch(:ordinary) { throw(:ordinary, 7) }
