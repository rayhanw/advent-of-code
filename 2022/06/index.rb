file = File.readlines("input.txt").map(&:strip)[0]
set = file.chars

## PART 1
mapped = set.map.with_index do |char, index|
  [
    *set[index..(index + 2)],
    set[index + 3]
  ]
end
first = mapped.find { |group| group.uniq.length == 4 }
p first
p mapped.index(first) + 1 + 3

## PART 2
mapped = set.map.with_index do |char, index|
  [
    *set[index..(index + 12)],
    set[index + 13]
  ]
end

first = mapped.find { |group| group.uniq.length == 14 }
p first
p mapped.index(first) + 1 + 13
