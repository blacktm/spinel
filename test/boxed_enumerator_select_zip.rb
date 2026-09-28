# select, filter, reject and zip on an Enumerator read out of a container
# walk its values, as on a typed Enumerator; flatten and map! stay Array's
# alone.
e = [[1, 2, 3].each, 0][0]
p e.select { |v| v > 1 }
p e.filter(&:odd?)
p e.reject { |v| v == 2 }
p e.zip([4, 5, 6])
p e.sort { |a, b| b <=> a }
p [(1..3).each, 0][0].select(&:even?)
f = (e.flatten rescue $!)
p f.class
g = (e.map! { |v| v } rescue $!)
p g.class
