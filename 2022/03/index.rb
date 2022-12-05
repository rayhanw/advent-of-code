file = File.readlines('input.txt').map(&:chomp)
small = ('a'..'z').to_a
big = ('A'..'Z').to_a
chars = small.map.with_index { |a, i| { key: a, num: i + 1 } }
big_chars = big.map.with_index { |a, i| { key: a, num: 27 + i } }
# A given rucksack always has the same number of items in each of its two compartments,
# so the first half of the characters represent items in the first compartment,
# while the second half of the characters represent items in the second compartment.
similarities = []
file.each do |line|
  chunked = line.chars.each_slice(line.length / 2).map(&:join)
  first = chunked[0]
  second = chunked[1]
  similar = []

  first.chars.each do |char|
    similar << char if second.include?(char)
  end
  similarities << similar
end

score = 0
result = similarities.map(&:uniq).flatten
result.each do |char|
  if small.include?(char)
    score += chars.find { |c| c[:key] == char }[:num]
  elsif big.include?(char)
    score += big_chars.find { |c| c[:key] == char }[:num]
  end
end

p score
