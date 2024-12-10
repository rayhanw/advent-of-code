require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
Y_MAX = FILE.size
X_MAX = FILE[0].size

starting_indices = []
POSSIBLE_ENDINGS = Hash.new { |h, k| h[k] = [] }

def print_eligibility(direction, rule, coordinate)
  light = rule ? "🟢" : "🔴"

  puts "#{direction} [#{coordinate.join(', ')}]: #{light}"
end

def traverse(map, starting_point, current_number, zero_coordinates)
  target = current_number + 1
  if target == 10
    POSSIBLE_ENDINGS[zero_coordinates] << starting_point
    return
  end

  x, y = starting_point
  up = [x, y - 1]
  up_eligible = y.positive? && map[up[1]][up[0]].to_i == target
  down = [x, y + 1]
  down_eligible = y < Y_MAX - 1 && map[down[1]][down[0]].to_i == target
  left = [x - 1, y]
  left_eligible = x.positive? && map[left[1]][left[0]].to_i == target
  right = [x + 1, y]
  right_eligible = x < X_MAX - 1 && map[right[1]][right[0]].to_i == target
  # puts "Traversing from (#{x}, #{y}) @#{current_number}->#{target}"
  # print_eligibility("Up", up_eligible, up)
  # print_eligibility("Down", down_eligible, down)
  # print_eligibility("Left", left_eligible, left)
  # print_eligibility("Right", right_eligible, right)
  # puts

  traverse(map, up, target, zero_coordinates) if up_eligible
  traverse(map, down, target, zero_coordinates) if down_eligible
  traverse(map, left, target, zero_coordinates) if left_eligible
  traverse(map, right, target, zero_coordinates) if right_eligible
end

time = Benchmark.measure do
  FILE.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      starting_indices << [x, y] if char == "0"

      colored = /\./.match?(char) ? char : char.colorize(:yellow)
      print "#{colored} "
    end
    puts
  end

  starting_indices.each do |(x, y)|
    # puts "Starting at (#{x}, #{y})"
    traverse(FILE, [x, y], 0, [x, y])
    # puts "Possible endings for 0@[#{x}, #{y}]: #{possible_endings.size}"
    # counter += possible_endings.size
  end

  all_possible_endings = POSSIBLE_ENDINGS.values.flatten(1)
  puts "Answer: #{all_possible_endings.size}".colorize(:green)
end

puts
puts time
