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

answers = []
starting_points.each do |starting_point, dirs|
  answer = 0
  point = starting_point.dup
  until point.end_with?('Z')
    ins = instructions[answer % instructions.length]
    current_spot = directions[point]
    direction = ins == 'L' ? :LEFT : :RIGHT
    point = current_spot[direction]
    answer += 1
  end
  answers << answer
end

puts ColorizedString['---------------------------------------------------------'].colorize(:cyan)
answer = answers.reduce(1) { |acc, n| acc.lcm(n) }
puts ColorizedString["Answer: #{answer}"].colorize(:green)
