require 'colorized_string'
require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file.reject { |ele| ele.empty? }
instructions = file[0].chars
directions = {}
file[1..].each do |line|
  l = line.split(' = ')
  position = l[0]
  line_direction = l[1].gsub(/\(|\)/, '').split(', ')

  directions[position] = { LEFT: line_direction[0], RIGHT: line_direction[1] }
end

pp instructions
pp directions

answer = 0
current_position = 'AAA'
until current_position == 'ZZZ'
  ins = instructions[answer % instructions.length]
  current_spot = directions[current_position]
  direction = ins == 'L' ? :LEFT : :RIGHT
  puts "dir #{direction} of #{current_position}"
  puts "#{current_spot}"
  current_position = current_spot[direction]
  puts "curr pos #{current_position}"
  puts
  answer += 1

  break if current_position == 'ZZZ'
end

puts ColorizedString['---------------------------------------------------------'].colorize(:cyan)
puts ColorizedString["Answer: #{answer}"].colorize(:green)
