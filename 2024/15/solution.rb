require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
DIRECTION = {
  "^" => [0, -1],
  "v" => [0, 1],
  "<" => [-1, 0],
  ">" => [1, 0]
}.freeze
COLORS = {
  "#" => :yellow,
  "O" => :light_blue,
  "@" => :green
}.freeze

def find_robot(map)
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      return [x, y] if char == "@"
    end
  end
end

def move!(map, instruction, x_max, y_max, count)
  robot_x, robot_y = find_robot(map)
  # puts "#{count}. Running instruction: #{instruction} at position: #{robot_x}, #{robot_y}"
  coordinates_adjuster = DIRECTION[instruction]
  coordinate_to_move_to = [robot_x + coordinates_adjuster[0], robot_y + coordinates_adjuster[1]]
  thing_at_coordinate = map[coordinate_to_move_to[1]][coordinate_to_move_to[0]]

  return if thing_at_coordinate == "#"

  if thing_at_coordinate == "."
    # Move robot
    map[robot_y][robot_x] = "."
    map[coordinate_to_move_to[1]][coordinate_to_move_to[0]] = "@"
  elsif thing_at_coordinate == "O"
    # Move box and any adjacent box
    case instruction
    when ">"
      adjascent_of_coord = map[coordinate_to_move_to[1]][coordinate_to_move_to[0]..]
      next_items_coordinates = adjascent_of_coord.map.with_index do |_line, idx|
        [coordinate_to_move_to[0] + idx, coordinate_to_move_to[1]]
      end
    when "<"
      adjascent_of_coord = map[coordinate_to_move_to[1]][0..coordinate_to_move_to[0]]
      next_items_coordinates = adjascent_of_coord.map.with_index do |_line, idx|
        [coordinate_to_move_to[0] - idx, coordinate_to_move_to[1]]
      end
    when "^"
      adjascent_of_coord = map[0..coordinate_to_move_to[1]].map { |line| line[coordinate_to_move_to[0]] }
      next_items_coordinates = adjascent_of_coord.map.with_index do |_line, idx|
        [coordinate_to_move_to[0], coordinate_to_move_to[1] - idx]
      end
    when "v"
      adjascent_of_coord = map[coordinate_to_move_to[1]..].map { |line| line[coordinate_to_move_to[0]] }
      next_items_coordinates = adjascent_of_coord.map.with_index do |_line, idx|
        [coordinate_to_move_to[0], coordinate_to_move_to[1] + idx]
      end
    end

    items_adjascent = adjascent_of_coord.join("").split("#")[%w[< ^].include?(instruction) ? -1 : 0].chars
    # puts "Items adjascent: #{items_adjascent}"

    # Do nothing if there are no place to move
    return unless items_adjascent.include?(".")

    map[robot_y][robot_x] = "."

    # Move box(es) & robot
    finder = %w[< ^].include?(instruction) ? :rindex : :index
    index_of_first_dot = items_adjascent.send(finder, ".")
    items_adjascent.delete_at(index_of_first_dot)
    # puts "Next items coordinates: #{next_items_coordinates}"
    # puts "After remove: #{items_adjascent}"
    items_adjascent.reverse! if %w[< ^].include?(instruction)
    new_list = ["@", *items_adjascent, "#"]
    # puts "New list: #{new_list}"
    new_list.each_with_index do |item, idx|
      coordinate = next_items_coordinates[idx]
      map[coordinate[1]][coordinate[0]] = item
    end
  end
end

def print_map(map)
  map.each do |line|
    line.each do |char|
      print "#{char.colorize(COLORS[char])} "
    end
    puts
  end
  puts
end

time = Benchmark.measure do
  map = []
  instructions = []
  starting_position = [nil, nil]

  FILE.each do |line|
    if line.start_with?("#")
      map << line.chars
    elsif line != ""
      instructions << line.chars
    end
  end
  instructions.flatten!

  puts "Starting map"
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      starting_position = [x, y] if char == "@"
      print "#{char.colorize(COLORS[char])} "
    end
    puts
  end
  puts

  x_max = map[0].size
  y_max = map.size

  instructions.each_with_index do |instruction, idx|
    move!(map, instruction, x_max, y_max, idx + 1)
    # print_map(map)
  end

  puts "Final map"
  print_map(map)

  coordinates = []
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      coordinates << [x, y] if char == "O"
    end
  end

  answer = coordinates.sum { |(x, y)| (100 * y) + x }
  puts "Answer: #{answer}".colorize(:green)
end

puts
puts time
