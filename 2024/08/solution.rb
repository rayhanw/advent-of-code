require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
X_MAX = FILE[0].length
Y_MAX = FILE.length
antenna_coordinates = Hash.new { |hash, key| hash[key] = [] }

def calculate_antinodes(first, second)
  # Calculate the midpoint between the two coordinates
  midpoint_x = (first[0] + second[0]) / 2.0
  midpoint_y = (first[1] + second[1]) / 2.0

  # Calculate the distance between the two coordinates
  dx = second[0] - first[0]
  dy = second[1] - first[1]

  # Create 2 perpendicular points from the midpoint
  # One rotated 90 degrees clockwise and the other 90 degrees counter-clockwise
  antinode_x1 = midpoint_x + dy
  antinode_y1 = midpoint_y - dx

  antinode_x2 = midpoint_x - dy
  antinode_y2 = midpoint_y + dx

  [[antinode_x1, antinode_y1], [antinode_x2, antinode_y2]]
end

def validate_antinodes(coordinates)
  coordinates => [x, y]
  x >= 0 && x < X_MAX && y >= 0 && y < Y_MAX
end

time = Benchmark.measure do
  FILE.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      if char != "."
        puts "#{char} at (#{x}, #{y})".colorize(:cyan)
        antenna_coordinates[char] << [x, y]
      end
    end
  end

  unique_antinodes = Set.new
  antenna_coordinates.each do |_frequency, coordinates|
    coordinates.combination(2).to_a.each do |pair|
      potential_antinodes = calculate_antinodes(pair[0], pair[1])
      potential_antinodes.each do |potential_antinode|
        unique_antinodes << potential_antinode if validate_antinodes(potential_antinode)
      end
    end
  end

  pp unique_antinodes.to_a
end

puts time
