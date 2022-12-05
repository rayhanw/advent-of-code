file = File.readlines('input.txt').map(&:chomp)
small = ('a'..'z').to_a
big = ('A'..'Z').to_a
groups = file.each_slice(3).to_a

result = groups.map do |group|
  a = (group[0].chars & group[1].chars & group[2].chars)[0]
  if small.include?(a)
    small.index(a) + 1
  else
    big.index(a) + 27
  end
end

p result.sum
