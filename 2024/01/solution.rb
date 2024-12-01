require 'colorize'

file = File.readlines('input.txt').map(&:strip).reject(&:empty?)
left = []
right = []
file.each do |line|
  line = line.split(' ')
  left << line[0].to_i
  right << line[1].to_i
end

# left.sort!
# right.sort!

# distances = []
# left.each_with_index do |num, idx|
#   distances << (right[idx] - num).abs
# end

# puts "Answer: #{distances.sum}".colorize(:green)

### Part 2 ###
counter = Hash.new(0)
left.each do |num|
  counter[num] += num * right.count(num)
end

puts "Answer: #{counter.values.sum}".colorize(:green)
