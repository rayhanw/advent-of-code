FILE = File.readlines("input.txt").map(&:strip)[0]
SET = FILE.chars

def packet_finder(character_count)
  low_limit = character_count - 2
  top_limit = character_count - 1
  mapped = SET.map.with_index do |char, index|
    [
      *SET[index..(index + low_limit)],
      SET[index + top_limit]
    ]
  end
  first = mapped.find { |group| group.uniq.length == character_count }
  mapped.index(first) + 1 + top_limit
end

# PART 1
p packet_finder(4)

# PART 2
p packet_finder(14)

### Separate attempts
## PART 1
# mapped = set.map.with_index do |char, index|
#   [
#     *set[index..(index + 2)],
#     set[index + 3]
#   ]
# end
# first = mapped.find { |group| group.uniq.length == 4 }
# p first
# p mapped.index(first) + 1 + 3

## PART 2
# mapped = set.map.with_index do |char, index|
#   [
#     *set[index..(index + 12)],
#     set[index + 13]
#   ]
# end

# first = mapped.find { |group| group.uniq.length == 14 }
# p first
# p mapped.index(first) + 1 + 13
