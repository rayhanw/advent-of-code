require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)

x_max = FILE[0].length
y_max = FILE.length
GUARD_FACE = {
  "^" => :up,
  "v" => :down,
  ">" => :right,
  "<" => :left
}.freeze

def determine_direction(char)
  GUARD_FACE[char]
end

def print_current_map(map, move_count)
  puts "> Move count: #{move_count}"
  map.each_with_index do |line, idx|
    line.each_char do |char|
      color = if char == "."
                :white
              elsif char == "#"
                :red
              else
                :green
              end
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

  puts "> Guard changed direction from #{direction} to #{guard_details[:direction]}"
end

def move!(map, guard_details)
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
    map[guard_details[:y]][guard_details[:x]] = GUARD_FACE.key(guard_details[:direction])
  else
    guard_details[:x] = x
    guard_details[:y] = y
    map[y][x] = GUARD_FACE.key(guard_details[:direction])
  end

  puts "> Guard moved to (#{x}, #{y})"
end

move_count = 0
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

loop do
  # 1. Print the current map
  # print_current_map(map, move_count)
  # 2. Mark the position of the guard with X
  map[guard_details[:y]][guard_details[:x]] = "X"
  # 3. Move the guard
  move!(map, guard_details)
  # 4. Check if the guard is at the edge of the map
  is_at_edge = guard_details[:x].zero? || guard_details[:x] == x_max - 1 || guard_details[:y].zero? || guard_details[:y] == y_max - 1
  break if is_at_edge

  # 5. Repeat until the guard is at the edge of the map
  move_count += 1
end

puts "\n\nFinal:"
# print_current_map(map, move_count)
puts "Answer: #{map.flatten.join('').count('X') + 1}"
