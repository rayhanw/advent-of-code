require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip).map(&:chars)

NUMERIC_KEYPAD = [
  %w[7 8 9],
  %w[4 5 6],
  %w[1 2 3],
  [nil, "0", "A"]
].freeze
NUMERIC_KEYPAD_STARTING_POINT = [2, 3].freeze
NUMERIC_KEYPAD_DEAD_ZONE = [3, 0].freeze

DIRECTIONAL_KEYPAD = [
  [nil, "^", "A"],
  ["<", "v", ">"]
].freeze
DIRECTIONAL_KEYPAD_STARTING_POINT = [0, 2].freeze
DIRECTIONAL_KEYPAD_DEAD_ZONE = [0, 0].freeze

def reconstruct_all_paths(predecessors, source, destination, path = [], all_paths = [])
  path.unshift(destination)

  if destination == source
    all_paths << path.dup
  elsif predecessors[destination]
    predecessors[destination].each do |predecessor|
      reconstruct_all_paths(predecessors, source, predecessor, path, all_paths)
    end
  end

  path.shift
  all_paths
end

def pathfind(graph, source, destination)
  distances = Hash.new(Float::INFINITY)
  distances[source] = 0
  predecessors = Hash.new { |h, k| h[k] = [] }
  priority_queue = [source]
  visited = Set.new

  # puts "Exploring: #{source}"
  until priority_queue.empty?
    current = priority_queue.min_by { |node| distances[node] }
    priority_queue.delete(current)
    visited.add(current)

    neighbors = graph[current]
    neighbors&.each do |neighbor|
      next if visited.include?(neighbor)

      tentative_distance = distances[current] + 1
      if tentative_distance < distances[neighbor]
        distances[neighbor] = tentative_distance
        predecessors[neighbor] = [current]
        priority_queue << neighbor
      elsif tentative_distance == distances[neighbor]
        predecessors[neighbor] << current
      end
    end
  end

  reconstruct_all_paths(predecessors, source, destination)
end

def build_graph(keypad, dead_zone)
  graph = {}
  x_max = keypad[0].size
  y_max = keypad.size

  keypad.each_with_index do |row, y|
    row.each_with_index do |char, x|
      neighbors = []

      up = [x, y - 1]
      neighbors << up if y.positive? && up != dead_zone

      down = [x, y + 1]
      neighbors << down if y < y_max && down != dead_zone

      left = [x - 1, y]
      neighbors << left if x.positive? && left != dead_zone

      right = [x + 1, y]
      neighbors << right if x < x_max && right != dead_zone

      graph[[x, y]] = neighbors
    end
  end

  graph.filter { |k, _v| k }
end

def translate_path(path)
  characters = []
  path.each_with_index do |coordinate, index|
    next_coordinate = path[index + 1]

    # TODO: This is wrong
    unless next_coordinate
      characters << "A"
      next
    end

    x_diff = (next_coordinate[0] - coordinate[0]).abs
    y_diff = (next_coordinate[1] - coordinate[1]).abs
    if x_diff.positive?
      characters << (next_coordinate[0] > coordinate[0] ? ">" : "<")
    elsif y_diff.positive?
      characters << (next_coordinate[1] > coordinate[1] ? "v" : "^")
    end
  end

  characters
end

time = Benchmark.realtime do
  ### START OF DATA PREP ###
  puts "--- Numeric Keypad ---"
  NUMERIC_KEYPAD.each do |row|
    row.each do |char|
      color = /\d+/.match?(char.to_s) ? :white : :yellow
      pretty_char = char.nil? ? " " : char
      print "#{pretty_char.to_s.colorize(color)} "
    end
    puts
  end
  puts " A (starting point): #{NUMERIC_KEYPAD_STARTING_POINT}".colorize(:blue)
  ## START Numeric data prep ##
  numeric_graph = build_graph(NUMERIC_KEYPAD, NUMERIC_KEYPAD_DEAD_ZONE)
  numeric_paths = Hash.new { |h, k| h[k] = {} }
  NUMERIC_KEYPAD.flatten.each do |button|
    next if button.nil?

    button_y = NUMERIC_KEYPAD.index { |row| row.include?(button) }
    button_x = NUMERIC_KEYPAD[button_y].index(button)
    # puts "Button: #{button} [#{button_x}, #{button_y}]"
    # Create all shortest paths from button to all other buttons
    (NUMERIC_KEYPAD.flatten - [button, nil]).each do |other_button|
      other_button_y = NUMERIC_KEYPAD.index { |row| row.include?(other_button) }
      other_button_x = NUMERIC_KEYPAD[other_button_y].index(other_button)
      # puts " Other Button: #{other_button} [#{other_button_x}, #{other_button_y}]"

      # puts "From #{button} [#{button_x}, #{button_y}] to #{other_button} [#{other_button_x}, #{other_button_y}]"
      path = pathfind(numeric_graph, [button_x, button_y], [other_button_x, other_button_y])
      # puts "  Path: #{path}"
      numeric_paths[button][other_button] = path
    end
    # puts
  end
  ## END Numeric data prep ##

  ## START Directional data prep ##
  puts
  puts "--- Directional Keypad ---"
  DIRECTIONAL_KEYPAD.each do |row|
    row.each do |char|
      color = char == "A" ? :yellow : :white
      pretty_char = char.nil? ? " " : char
      print "#{pretty_char.to_s.colorize(color)} "
    end
    puts
  end
  puts "A (starting point): #{DIRECTIONAL_KEYPAD_STARTING_POINT}".colorize(:blue)

  directional_graph = build_graph(DIRECTIONAL_KEYPAD, DIRECTIONAL_KEYPAD_DEAD_ZONE)
  directional_paths = Hash.new { |h, k| h[k] = {} }
  DIRECTIONAL_KEYPAD.flatten.each do |button|
    next if button.nil?

    button_y = DIRECTIONAL_KEYPAD.index { |row| row.include?(button) }
    button_x = DIRECTIONAL_KEYPAD[button_y].index(button)
    # puts "Button: #{button} [#{button_x}, #{button_y}]"
    # Create all shortest paths from button to all other buttons
    (DIRECTIONAL_KEYPAD.flatten - [button, nil]).each do |other_button|
      other_button_y = DIRECTIONAL_KEYPAD.index { |row| row.include?(other_button) }
      other_button_x = DIRECTIONAL_KEYPAD[other_button_y].index(other_button)
      # puts " Other Button: #{other_button} [#{other_button_x}, #{other_button_y}]"

      # puts "From #{button} [#{button_x}, #{button_y}] to #{other_button} [#{other_button_x}, #{other_button_y}]"
      path = pathfind(directional_graph, [button_x, button_y], [other_button_x, other_button_y])
      # puts "  Path: #{path}"
      directional_paths[button][other_button] = path
    end
    # puts
  end
  ## END Directional data prep ##
  ### END OF DATA PREP ###

  instructions = FILE.map(&:join)
  puts
  puts "--- Instructions ---"
  counter = 0
  instructions.size.times do |i|
    puts "Running instruction: #{instructions[i]}"
    # Robot #1 -> Numeric movement
    robot_one_movements = [instructions[i]].map do |instruction|
      current = "A"
      # movements = []
      path = instruction.chars.map.each do |character|
        # puts "  Moving to: #{character} from #{current}"
        possible_paths = numeric_paths[current][character]
        # For simplicity, we'll just take the first path
        # p possible_paths
        first_possible_path = possible_paths.first
        movement_detail = { from: current, to: character, path: first_possible_path }
        current = character
        { original: first_possible_path, translated: translate_path(movement_detail[:path]).join }
      end

      { instruction:, original: path.map { |p| p[:original] }, translated: path.map { |p| p[:translated] }.join }
    end
    robot_one_movements.map! do |movement|
      original = ([[NUMERIC_KEYPAD_STARTING_POINT]] + movement[:original].map { |path| path[1..] }).flatten(1)
      in_characters = movement[:translated]

      # puts "Instruction: #{movement[:instruction]}"
      # puts " #{original}".colorize(:red)
      # puts " #{in_characters}".colorize(:green)

      { instruction: movement[:instruction], original: original, translated: in_characters }
    end

    # p robot_one_movements[0][:original]
    # Sample: [[2, 3], [2, 2], [1, 2], [0, 2], [0, 1], [0, 0], [1, 0], [2, 0], [2, 1], [2, 2], [2, 3]]
    # puts robot_one_movements[0][:translated]
    # p robot_one_movements

    # Robot #2 -> Directional movement to control Robot #1's numeric movement
    robot_two_movements = []
    robot_one_movements.each do |movement|
      # puts "Instruction: #{movement[:instruction]}"
      # puts " #{movement[:original]}".colorize(:yellow)
      # puts " #{movement[:translated]}".colorize(:yellow)
      previous = nil
      current = "A"
      move = movement[:translated].chars.map.with_index do |character, index|
        possible_paths = directional_paths[current][character]
        # if index == 1
        #   puts "Current: #{current} to #{character}"
        #   puts " All possible paths: #{possible_paths}"
        # end
        # puts "  Current: #{current} | Character: #{character}"
        # For simplicity, we'll just take the first path
        # first_possible_path = index == 1 ? possible_paths&.last : possible_paths&.first
        # pp possible_paths
        first_possible_path = possible_paths&.find do |path|
          first = path.first
          last = path.last
          x_diff = (last[0] - first[0])
          y_diff = (last[1] - first[1])
          if x_diff >= 0
            # puts "Prioritizing X"
            abs_x_diff = x_diff.abs
            path[0..abs_x_diff].map { |coordinate| coordinate[0] }.uniq.size - 1 == abs_x_diff
          elsif y_diff >= 0
            # puts "Prioritizing Y"
            abs_y_diff = y_diff.abs
            path[0..abs_y_diff].map { |coordinate| coordinate[1] }.uniq.size - 1 == abs_y_diff
          elsif x_diff.negative? && y_diff.negative?
            puts "HANDLE SPECIAL CASE"
            # else
            #   p path
            #   puts "x_diff: #{x_diff}"
            #   puts "y_diff: #{y_diff}"
            #   puts "HANDLE"
          end
        end
        movement_detail = { from: current, to: character, path: first_possible_path }
        previous = current
        current = character

        # puts "First possible: #{first_possible_path}"

        # When the previous and current character are the same, we just need to press the button
        if previous == current
          # puts "   A"
          result = {
            original_char: character,
            original: [],
            translated: ["A"]
          }
        else
          translated = translate_path(movement_detail[:path]).join
          # puts "   #{translated}"
          result = {
            original_char: character,
            original: first_possible_path,
            translated:
          }
        end
        # puts "  Result: #{result}"
        result
      end

      robot_two_movements << move
    end

    robot_two_movements.flatten!(1)
    puts(robot_two_movements.map { |movement| movement[:translated] }.join)
    # robot_two_movements.each do |movement|
    #   puts "Instruction: #{movement[:original_char].colorize(:yellow)}"
    #   puts " #{movement[:original]}".colorize(:blue)
    #   puts " #{movement[:translated]}".colorize(:green)
    # end
    # puts robot_two_movements.map { |movement| movement[:original_char] }.join
    robot_two_movements_in_character = robot_two_movements.map { |movement| movement[:translated] }.join
    # robot_two_movements_in_coordinates = robot_two_movements.map { |movement| movement[:original] }
    # puts robot_two_movements_in_character.colorize(:green)

    # Robot #3 -> Directional movement to control Robot #2's directional movement
    current = "A"
    previous = nil
    robot_three_movements = robot_two_movements_in_character.chars.map do |character|
      possible_paths = directional_paths[current][character]
      first_possible_path = possible_paths&.first
      movement_detail = { from: current, to: character, path: first_possible_path }
      previous = current
      current = character

      if previous == current
        # puts "   A"
        {
          original_char: character,
          original: [],
          translated: "A"
        }
      else
        translated = translate_path(movement_detail[:path]).join
        # puts "   #{translated}"
        result = {
          original_char: character,
          original: first_possible_path,
          translated:
        }
        result
      end
    end

    movement_path = robot_three_movements.map { |movement| movement[:translated] }.join
    puts movement_path
    instruction_number = instructions[i].scan(/\d+/).first.to_i
    complexity = movement_path.size * instruction_number
    puts "Instruction: #{instructions[i]}".colorize(:yellow)
    puts "#{movement_path.size} * #{instruction_number}".colorize(:blue)
    puts "Complexity: #{complexity}".colorize(:green)
    counter += complexity
  end

  puts "\n\nAnswer: #{counter}".colorize(:green)
end

puts
puts "Time: #{time.round(2)}s".colorize(:yellow)
