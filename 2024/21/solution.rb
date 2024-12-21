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

def prepare_data
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
  puts
  ## START Directional data prep ##
  puts "--- Directional Keypad ---"
  DIRECTIONAL_KEYPAD.each do |row|
    row.each do |char|
      color = char == "A" ? :yellow : :white
      pretty_char = char.nil? ? " " : char
      print "#{pretty_char.to_s.colorize(color)} "
    end
    puts
  end

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

  { numeric_paths:, directional_paths: }
end

time = Benchmark.realtime do
  prepare_data => { numeric_paths:, directional_paths:}
  puts

  instructions = FILE.map(&:join)
  instructions[0...1].each do |instruction|
    puts "Running: #{instruction}"

    current = "A"
    instruction_chars = instruction.chars
    instruction_chars.each do |character|
      possibilities = []
      possible_paths = numeric_paths[current][character]
      possible_paths.each do |possible_path|
        movement_detail = { from: current, to: character, path: possible_path }
        current = character
        result = { original: possible_path, translated: translate_path(movement_detail[:path]).join }
        possibilities << result
      end
      puts " #{character}: #{possibilities}"
    end

    paths = instruction.chars.map.each do |character|
      # puts "  Moving to: #{character} from #{current}"
      possible_paths = numeric_paths[current][character]
      # For simplicity, we'll just take the first path
      # p possible_paths
      first_possible_path = possible_paths.first
      movement_detail = { from: current, to: character, path: first_possible_path }
      current = character
      { original: first_possible_path, translated: translate_path(movement_detail[:path]).join }
    end
  end
end

puts
puts "Time: #{time.round(2)}s".colorize(:yellow)
