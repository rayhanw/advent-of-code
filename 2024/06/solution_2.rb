require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)

x_max = FILE[0].length - 1
y_max = FILE.length - 1
GUARD_FACE = {
  "^" => :up,
  "v" => :down,
  ">" => :right,
  "<" => :left
}.freeze
CHARACTER_COLOR = {
  "." => :white,
  "#" => :red,
  "X" => :gray
}.freeze

def determine_direction(char)
  GUARD_FACE[char]
end

def print_current_map(map)
  map.each_with_index do |line, idx|
    line.each_char do |char|
      color = CHARACTER_COLOR[char] || :green
      print "#{char} ".colorize(color)
    end
    puts
  end
end

def change_direction!(guard_details)
  direction = guard_details[:direction]

  case direction
  when :up
    guard_details[:direction] = :right
  when :down
    guard_details[:direction] = :left
  when :right
    guard_details[:direction] = :down
  when :left
    guard_details[:direction] = :up
  end

  # puts "> Guard changed direction from #{direction} to #{guard_details[:direction]}"
end

def move!(map, guard_details, change_direction_coordinates)
  x = guard_details[:x]
  y = guard_details[:y]
  direction = guard_details[:direction]

  case direction
  when :up
    y -= 1
  when :down
    y += 1
  when :right
    x += 1
  when :left
    x -= 1
  end

  if map[y][x] == "#"
    change_direction!(guard_details)
    change_direction_coordinates << [guard_details[:x], guard_details[:y]]
    map[guard_details[:y]][guard_details[:x]] = GUARD_FACE.key(guard_details[:direction])
  else
    guard_details[:x] = x
    guard_details[:y] = y
    map[y][x] = GUARD_FACE.key(guard_details[:direction])
  end

  # puts "> Guard moved to (#{x}, #{y})"
end

guard_details = {
  x: 0,
  y: 0,
  direction: nil
}
FILE.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    if %w[^ v > <].include?(char)
      puts "> Found Guard at (#{x}, #{y})"
      guard_details = { x:, y:, direction: determine_direction(char) }

      break
    end
  end
end

map = [*FILE]
change_direction_coordinates = []

loop do
  # 1. Print the current map
  # print_current_map(map)
  # 2. Mark the position of the guard with X
  map[guard_details[:y]][guard_details[:x]] = "X"
  # 3. Move the guard
  move!(map, guard_details, change_direction_coordinates)
  # 4. Check if the guard is at the edge of the map
  is_at_edge = guard_details[:x].zero? || guard_details[:x] == x_max || guard_details[:y].zero? || guard_details[:y] == y_max
  # 5. Repeat until the guard is at the edge of the map
  break if is_at_edge
end

pairs = change_direction_coordinates.combination(2).to_a
change_direction_coordinates.each do |(x, y)|
  map[y][x] = "+"
end
pairs.each do |(beginning, ending)|
  x_diff = ending[0] - beginning[0]
  y_diff = ending[1] - beginning[1]
  puts "#{beginning} => #{ending}"
  if x_diff.abs.positive?
    puts "Moving #{x_diff} steps horizontally"
    x_spots = if x_diff.positive?
                ((beginning[0] + 1)...ending[0])
              else
                ((ending[0] + 1)...beginning[0])
              end
    x_spots.each do |x|
      char_at_spot = map[ending[1]][x]
      map[ending[1]][x] = "-" if ["X"].include?(char_at_spot)
    end
  else
    puts "Moving #{y_diff} steps vertically"
    y_spots = if y_diff.positive?
                ((beginning[1] + 1)...ending[1])
              else
                ((ending[1] + 1)...beginning[1])
              end
    y_spots.each do |y|
      char_at_spot = map[y][ending[0]]
      map[y][ending[0]] = "|" if ["X"].include?(char_at_spot)
    end
  end
  puts
end
print_current_map(map)

change_direction_coordinates.combination(3).to_a.each do |pair|
  x_counts = pair.group_by { |coord| coord[0] }
  x_rule_met = x_counts.any? { |_x, group| group.size == 2 }
  y_counts = pair.group_by { |coord| coord[1] }
  y_rule_met = y_counts.any? { |_y, group| group.size == 2 }
  next unless x_rule_met && y_rule_met

  puts "#{pair} => 🟢"
end
