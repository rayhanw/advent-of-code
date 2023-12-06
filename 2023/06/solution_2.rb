require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
time = file[0].gsub('Time:', '').strip.gsub(/\s+/, '').to_i
distance = file[1].gsub('Distance:', '').strip.gsub(/\s+/, '').to_i
puts "Time #{time}"
puts "Distance #{distance}"
puts

possibilities = []
count = 0
(time + 1).times do |i|
  hold_time = i
  possibility = { hold: hold_time, travelled: (time - hold_time) * hold_time }
  count += 1 if possibility[:travelled] > distance
end

p count
