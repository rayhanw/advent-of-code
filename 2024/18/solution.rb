require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
SIZE = 70 # 70 for real input, sample input: 6
FIRST_BYTES = 1024 # 1024 for real input, sample input: 12

COLORS = {
  "." => { color: :white },
  "#" => { color: :white },
  "O" => { color: :green, mode: :bold }
}.freeze

def print_map(grid)
  grid.each do |line|
    line.each do |char|
      print "#{char.colorize(COLORS[char])} "
    end
    puts
  end
end

def find_neighbors(grid, coordinate)
  x, y = coordinate
  up = [x, y - 1]
  down = [x, y + 1]
  left = [x - 1, y]
  right = [x + 1, y]

  neighbors = []

  neighbors << up if up[1] >= 0 && grid[up[1]][up[0]] != "#"
  neighbors << down if down[1] <= SIZE && grid[down[1]][down[0]] != "#"
  neighbors << left if left[0] >= 0 && grid[left[1]][left[0]] != "#"
  neighbors << right if right[0] <= SIZE && grid[right[1]][right[0]] != "#"

  neighbors
end

def build_graph(grid)
  graph = Hash.new { |h, k| h[k] = [] }

  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if char == "#"

      neighbors = find_neighbors(grid, [x, y])
      graph[[x, y]] = neighbors
    end
  end

  graph
end

def dijkstra(graph, starting_point, ending_point)
  distances = Hash.new(Float::INFINITY)
  distances[starting_point] = 0
  predecessors = {}
  # Track visited nodes
  visited = Set.new

  # [node, distance]
  priority_queue = [[starting_point, 0]]

  until priority_queue.empty?
    # Pop the node with the smallest distance
    current_node, current_distance = priority_queue.min_by { |_, distance| distance }
    priority_queue.delete([current_node, current_distance])
    next if visited.include?(current_node)

    # Mark the node as visited
    visited.add(current_node)

    # Stop if destination is reached
    break if current_node == ending_point

    # Find the neighbors of the current node
    neighbors = graph[current_node]
    neighbors&.each do |neighbor|
      # Skip if the neighbor has been visited
      next if visited.include?(neighbor)

      new_distance = current_distance + 1 # Unweighted graph
      # rubocop:disable Style/Next
      if new_distance < distances[neighbor]
        distances[neighbor] = new_distance
        priority_queue << [neighbor, new_distance]
        predecessors[neighbor] = current_node
      end
      # rubocop:enable Style/Next
    end
  end

  { distances:, predecessors: }
end

def reconstruct_path(predecessors, ending_point)
  current_node = ending_point
  path = []
  while current_node
    path.unshift(current_node)
    current_node = predecessors[current_node]
  end

  path
end

time = Benchmark.realtime do
  # Build a 70x70 grid
  grid = Array.new(SIZE + 1) { Array.new(SIZE + 1, ".") }
  coordinates = []

  FILE.each do |line|
    coordinates << line.split(",").map(&:to_i)
  end

  starting_point = [0, 0]
  ending_point = [SIZE, SIZE]

  # puts "--- Initial Map ---"
  adjuster = 0
  last_coordinate = nil
  loop do
    cloned_grid = grid.map(&:clone)
    falling_bytes_coordinates = coordinates[0...(FIRST_BYTES + adjuster)]
    # puts "FBC: #{falling_bytes_coordinates}"
    falling_bytes_coordinates.each do |(x, y)|
      cloned_grid[y][x] = "#"
    end
    graph = build_graph(cloned_grid)
    result = dijkstra(graph, starting_point, ending_point)
    # puts "Last predecessor: #{last_predecessor}"
    last_coordinate = falling_bytes_coordinates.last
    reached_end = result[:predecessors].keys.include? ending_point
    puts "Adjuster: #{adjuster} -> 0..#{FIRST_BYTES + adjuster} -> #{reached_end ? '✅' : '❌'}"
    # puts "Reached ending: #{reached_end ? '✅' : '❌'}"
    # path = reconstruct_path(result[:predecessors], ending_point)
    # path.each do |(x, y)|
    #   cloned_grid[y][x] = "O"
    # end
    # print_map(cloned_grid)
    # puts

    break unless reached_end

    adjuster += 1
  end

  puts "Answer: #{last_coordinate.join(',')}".colorize(color: :green)

  # falling_bytes_coordinates = coordinates[0...FIRST_BYTES + 9]
  # falling_bytes_coordinates.each do |(x, y)|
  #   grid[y][x] = "#"
  # end
  # # print_map(grid)

  # graph = build_graph(grid)
  # # puts "--- Graph ---"
  # # pp graph
  # result = dijkstra(graph, starting_point, ending_point)
  # # puts "-" * 50
  # # puts "--- Distances ---"
  # # pp result[:distances]
  # puts "--- Predecessors ---"
  # pp result[:predecessors]
  # # puts "--- Shortest path ---"
  # path = reconstruct_path(result[:predecessors], ending_point)
  # pp path
  # path.each do |(x, y)|
  #   grid[y][x] = "O"
  # end

  # # puts "--- Final map ---"
  # # print_map(grid)

  # answer = grid.flatten.count("O") - 1
  # puts "Answer: #{answer}".colorize(color: :green)
end

puts
puts "Time: #{time.round(2)}s".colorize(color: :yellow)
