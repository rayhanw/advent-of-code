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

def change_map_for_p2!(map)
  # If # -> ##
  # If O -> []
  # If . -> ..
  # If @ -> @.
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      map[y][x] = %w[# #] if char == "#"
      map[y][x] = ["[", "]"] if char == "O"
      map[y][x] = %w[. .] if char == "."
      map[y][x] = %w[@ .] if char == "@"
    end
    map[y] = map[y].flatten
  end
end

def find_follow_up(map, coordinate)
  return nil if %w[. #].include? map[coordinate[1]][coordinate[0]]

  # Find what is the item at the coordinate
  thing_at_coordinate = map[coordinate[1]][coordinate[0]]
  # If the item is a closing square bracket, we need to find the opening square bracket
  coordinate_of_pair = if thing_at_coordinate == "]"
                         [coordinate[0] - 1, coordinate[1]]
                       else
                         [coordinate[0] + 1, coordinate[1]]
                       end

  #  Arrange the coordinates so that the opening square bracket is first
  if thing_at_coordinate == "]"
    [coordinate_of_pair, coordinate]
  else
    [coordinate, coordinate_of_pair]
  end
end

def print_map(map)
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      print "#{char.colorize(COLORS[char])} "
    end
    puts
  end
end

def move!(map, instruction, count)
  robot_x, robot_y = find_robot(map)
  puts "#{count}. Running instruction: #{instruction} at position: #{robot_x}, #{robot_y}"
  coordinates_adjuster = DIRECTION[instruction]
  coordinate_to_move_to = [robot_x + coordinates_adjuster[0], robot_y + coordinates_adjuster[1]]
  thing_at_coordinate = map[coordinate_to_move_to[1]][coordinate_to_move_to[0]]

  return if thing_at_coordinate == "#"

  if thing_at_coordinate == "."
    # Move robot
    map[robot_y][robot_x] = "."
    map[coordinate_to_move_to[1]][coordinate_to_move_to[0]] = "@"
  elsif ["[", "]"].include?(thing_at_coordinate)
    if %w[^ v].include?(instruction)
      # Do something for P2
      # puts "coordinate_to_move_to: #{coordinate_to_move_to}"
      # Find opening/closing square bracket
      pair_coordinate = find_follow_up(map, coordinate_to_move_to)
      # puts "Pair coordinate: #{pair_coordinate}"
      connected_squares = [pair_coordinate]
      stack = [pair_coordinate]

      until stack.empty?
        coordinates = stack.pop
        coordinates.each do |coordinate|
          follow_up_pair = find_follow_up(map,
                                          [coordinate[0] + coordinates_adjuster[0],
                                           coordinate[1] + coordinates_adjuster[1]])

          # puts "Coord: #{coordinate} | Follow up pair: #{follow_up_pair}"
          connected_squares << follow_up_pair if follow_up_pair && !connected_squares.include?(follow_up_pair)
          stack << follow_up_pair if follow_up_pair
        end
      end
      # puts "Connected squares: #{connected_squares}"
      if instruction == "^"

        connected_squares.flatten(1).each do |coordinate|
          puts "Checking connected coordinate #{coordinate}"
          thing_above = map[coordinate[1] - 1][coordinate[0]]
          # Do nothing if there is a wall above
          return if thing_above == "#"
        end

        connected_squares.sort_by { |pair| pair[0][1] }.each do |pair|
          pair.each_with_index do |coordinate, idx|
            shifted_coordinate = [coordinate[0], coordinate[1] - 1]
            # puts "From #{coordinate} -> #{shifted_coordinate}"
            map[shifted_coordinate[1]][shifted_coordinate[0]] = idx.zero? ? "[" : "]"
            map[coordinate[1]][coordinate[0]] = "."
          end
        end
      else
        connected_squares.flatten(1).each do |coordinate|
          thing_below = map[coordinate[1] + 1][coordinate[0]]
          # Do nothing if there is a wall below
          return if thing_below == "#"
        end

        connected_squares.sort_by { |pair| pair[0][1] }.reverse.each do |pair|
          pair.each_with_index do |coordinate, idx|
            shifted_coordinate = [coordinate[0], coordinate[1] + 1]
            # puts "From #{coordinate} -> #{shifted_coordinate}"
            map[shifted_coordinate[1]][shifted_coordinate[0]] = idx.zero? ? "[" : "]"
            map[coordinate[1]][coordinate[0]] = "."
          end
        end
      end

      map[robot_y][robot_x] = "."
      map[coordinate_to_move_to[1]][coordinate_to_move_to[0]] = "@"

      return
    end

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

  change_map_for_p2!(map)

  puts "Starting map"
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      starting_position = [x, y] if char == "@"
      print "#{char.colorize(COLORS[char])}"
    end
    puts
  end
  puts

  instructions.each_with_index do |instruction, idx|
    move!(map, instruction, idx + 1)
    # print_map(map)
    puts
    # sleep(0.5)
    # system("clear")
  end

  puts "Final map".colorize(:magenta)
  print_map(map)

  coordinates = []
  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      coordinates << [x, y] if char == "["
    end
  end

  answer = coordinates.sum { |(x, y)| (100 * y) + x }
  puts "Answer: #{answer}".colorize(:green)
end

puts
puts time

# P2: 1.438.185 -> Too low
# P2: 2.876.370 -> Too high
# P2: 2.157.277 -> Too high
# P2: 1797731 -> x
