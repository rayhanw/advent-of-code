require_relative '../../helpers/advent_of_code'
require_relative './helpers'

ANSWERS = [
  6499, # 1. Too low
  6500, # 2. Too low
  6909
].freeze

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file.map(&:chars)
map = [*file]

# 1. Find starting position
x = nil
y = nil
found = false
file.each_with_index do |line, y2|
  line.each_with_index do |char, x2|
    if char == 'S'
      x = x2
      y = y2
      found = true
      break
    end
  end

  break if found
end

traversed_coordinates = [[y, x]]

puts "*** Initial Map ***"
file.each do |line|
  p line
end
puts "Start: [#{y}, #{x}]"
possible_coordinates = get_possible_coordinates([y, x], file)
haha = possible_coordinates.map do |coord|
  get_possible_directions(coord, file, [y, x])
end.filter { |val| val[:possibilities].include?(val[:direction]) }
possible_coordinates = haha.map { |val| val[:coords] }
pp possible_coordinates

counter = 0
loop do
  pc = []
  possible_coordinates.each do |coordinate|
    pc << get_possible_coordinates(coordinate, file)
    traversed_coordinates << coordinate
  end

  pc.flatten!(1)
  pc.uniq!
  pc.reject! { |coordinate| traversed_coordinates.include?(coordinate) }

  counter += 1
  possible_coordinates = pc
  pp pc

  break if pc.empty?
end

puts "ANSWER: #{counter}"

# pc1 = get_possible_coordinates([y, x], file)
# pc2 = []
# pc1.each do |coordinate|
#   pc2 << get_possible_coordinates(coordinate, file)
#   traversed_coordinates << coordinate
# end
# pc2.flatten!(1)
# pc2.uniq!
# pc2.reject! { |coordinate| traversed_coordinates.include?(coordinate) }

# puts "Possible coordinates: #{pc2}"
