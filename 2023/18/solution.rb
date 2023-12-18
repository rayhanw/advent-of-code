require 'colorized_string'
require 'English'
require_relative 'helpers'

ANSWERS = [
  221_870, # 1. Too high
  437_542, # 2. Too high
  210_259, # 3. Too high
].freeze

inputs = $DEFAULT_INPUT.map(&:chomp).map do |line|
  direction, distance, color = line.split(' ')
  color.gsub!(/(\(|\))/, '')

  { direction:, distance: distance.to_i, color: }
end

grouped_inputs = { horizontal: [], vertical: [] }
inputs.each do |input|
  dir = %w[R L].include?(input[:direction]) ? :horizontal : :vertical
  grouped_inputs[dir] << input
end

X_MAX = grouped_inputs[:horizontal].filter { |ele| ele[:direction] == 'R' }.map { |ele| ele[:distance] }.sum
Y_MAX = grouped_inputs[:vertical].filter { |ele| ele[:direction] == 'U' }.map { |ele| ele[:distance] }.sum

grid = Array.new(Y_MAX + 1) { Array.new(X_MAX, '.') }
grid[0][0] = '#'
last_coordinate = [0, 0]

inputs.each do |line|
  line => { direction:, distance:, color: }

  if direction == 'R'
    x_start = last_coordinate[0]
    x_end = last_coordinate[0] + distance
    y = last_coordinate[1]
    puts "Marking horizontally from #{x_start} to #{x_end} at verticality: #{y}"
    (x_start..x_end).each do |x|
      grid[y][x] = '#'
    end
    last_coordinate[0] = x_end
  elsif direction == 'D'
    y_start = last_coordinate[1]
    y_end = last_coordinate[1] + distance
    x = last_coordinate[0]
    puts "Marking vertically from #{y_start} to #{y_end} at horizontality: #{x}"
    (y_start..y_end).each do |i|
      grid[i][x] = '#'
    end
    last_coordinate[1] = y_end
  elsif direction == 'L'
    x_start = last_coordinate[0]
    x_end = last_coordinate[0] - distance
    x_min = [x_start, x_end].min
    x_max = [x_start, x_end].max
    y = last_coordinate[1]
    puts "Marking horizontally from #{x_min} to #{x_max} at verticality: #{y}"
    (x_min..x_max).each do |i|
      grid[y][i] = '#'
    end
    last_coordinate[0] = x_end
  elsif direction == 'U'
    y_start = last_coordinate[1]
    y_end = last_coordinate[1] - distance
    y_min = [y_start, y_end].min
    y_max = [y_start, y_end].max
    x = last_coordinate[0]
    puts "Marking vertically from #{y_min} to #{y_max} at horizontality: #{x}"
    (y_min..y_max).each do |i|
      grid[i][x] = '#'
    end
    last_coordinate[1] = y_end
  end
end

# grid.each do |line|
#   puts line.join(' ')
# end

sum = 0
filled = fill_between_hashes(grid)
filled.each do |line|
  # puts line.join(' ')
  hash_count = line.join('').count('#')
  sum += hash_count
end

puts ColorizedString["Answer: #{sum}"].colorize(:green)
