require 'colorized_string'
require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file.reject(&:empty?)
instructions = file[0].chars
directions = {}
file[1..].each do |line|
  l = line.split(' = ')
  position = l[0]
  line_direction = l[1].gsub(/\(|\)/, '').split(', ')

  directions[position] = { LEFT: line_direction[0], RIGHT: line_direction[1] }
end

starting_points = directions.select { |direction, _| direction.end_with?('A') }
pp starting_points

answer = 0
current_positions = starting_points.keys
until current_positions.all? { |pos| pos.end_with?('Z') }
  lol = current_positions.map do |current_position|
    ins = instructions[answer % instructions.length]
    current_spot = directions[current_position]
    direction = ins == 'L' ? :LEFT : :RIGHT
    # puts current_spot
    current_position = current_spot[direction]
    # puts "curr pos #{current_position}"

    current_position
  end

  current_positions = lol
  answer += 1
  p lol
end

puts ColorizedString['---------------------------------------------------------'].colorize(:cyan)
puts ColorizedString["Answer: #{answer}"].colorize(:green)
