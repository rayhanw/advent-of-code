require "colorize"
require "benchmark"

FILE = File.readlines("input.txt").map(&:strip)
X_MAX = FILE[0].size
Y_MAX = FILE.size
COLORS = {
  "#" => :light_blue,
  "." => :white,
  "S" => :yellow,
  "E" => :magenta,
  "v" => :light_yellow,
  "^" => :light_red,
  ">" => :light_green,
  "<" => :light_blue
}.freeze
DIRECTIONS = {
  north: [0, -1],
  east: [1, 0],
  south: [0, 1],
  west: [-1, 0]
}.freeze
DIRECTION_COLOR = {
  north: :light_red,
  east: :light_green,
  west: :light_blue,
  south: :light_yellow
}.freeze
DIRECTION_LABEL = {
  north: "^",
  east: ">",
  west: "<",
  south: "v"
}.freeze

map = FILE.map(&:chars)

### Dijkstra's Algorithm
# Ref: https://www.youtube.com/watch?v=EFg3u_E6eHU
# The whole idea:
# To find the shortest path from a source node to all other nodes in the graph
# Ultimately, we want to find the shortest path from the source node to a target node
# The algorithm works by keeping track of the shortest distance from the source node to all other nodes
# It does this by "labeling" the nodes with the shortest distance from the source node
#
# The algorithm works as follows:
# 1. Assign an initial distance of 0 to the source node and ∞ (infinity) to all other nodes
# 2. Mark all nodes as unvisited. Create an empty list to store the visited nodes
# 3. Create a priority queue and add the source node to it
# 4. While the priority queue is not empty, do the following:
#   a. Find the node with the smallest distance in the priority queue
#   b. Mark this node as visited
#   c. For each neighbor of the current node, calculate the distance from the source node
#   d. If the calculated distance is less than the current distance, update the distance
#   e. Add the neighbor to the priority queue
#   f. Repeat until the priority queue is empty
# 5. Return the distances
###
def solve_with_dijkstra(graph, starting_position, _ending_position, initial_direction)
  # Assign an initial distance of 0 to the source node and ∞ (infinity) to all other nodes
  distances = Hash.new(Float::INFINITY)
  distances[[starting_position, initial_direction]] = 0
  predecessors = {}
  # Mark all nodes as unvisited. Create an empty list to store the visited nodes
  visited = []
  priority_queue = [[starting_position, initial_direction]]
  until priority_queue.empty?
    # smallest_distance_node => [coordinate, direction]
    smallest_distance_node = priority_queue.min_by { |(node, direction)| distances[[node, direction]] }
    current_coordinate = smallest_distance_node[0]
    current_direction = smallest_distance_node[1]
    current_cost = distances[smallest_distance_node]
    priority_queue.delete(smallest_distance_node)
    visited << smallest_distance_node
    neighbors = graph[smallest_distance_node[0]]
    neighbors.each do |neighbor|
      DIRECTIONS.each do |direction, (dx, dy)|
        direction_is_valid = filtered_directions(current_direction).include?(direction)
        next unless direction_is_valid

        valid_neighbor = neighbor == [current_coordinate[0] + dx, current_coordinate[1] + dy]
        next unless valid_neighbor

        move_cost = 1
        turn_cost = current_direction.to_s.downcase == direction.to_s.downcase ? 0 : 1000
        tentative_distance = current_cost + move_cost + turn_cost
        next if tentative_distance > distances[[neighbor, direction]]

        # puts "From: #{current_coordinate}"
        # puts "  -> #{neighbor} facing #{direction.to_s.colorize(DIRECTION_COLOR[direction])} (prev: #{current_direction.to_s.colorize(DIRECTION_COLOR[current_direction])}) with a cost of (CC: #{current_cost}, MC: #{move_cost}, TC: #{turn_cost})"
        distances[[neighbor, direction]] = tentative_distance
        predecessors[[neighbor, direction]] = smallest_distance_node
        priority_queue << [neighbor, direction]
      end
    end
  end

  { distances:, predecessors: }
end

def filtered_directions(current_direction)
  {
    north: %i[north east west],
    east: %i[east north south],
    south: %i[south east west],
    west: %i[west north south]
  }[current_direction]
end

def reconstruct_path(distances, predecessors, destination)
  path = []
  current_node = destination
  direction = distances.keys.find { |(pos, cur)| pos == current_node && distances[[pos, cur]] < Float::INFINITY }&.last

  while current_node
    path.unshift([current_node, direction]) # Add the current node to the beginning of the path
    current_node, direction = predecessors[[current_node, direction]] # Move to the previous node
  end

  path.reverse
end

def print_map(map)
  map.each_with_index do |row, y|
    row.each_with_index do |char, x|
      print "#{char.colorize(COLORS[char])} "
    end
    puts
  end
end

def changed_direction?(previous_coordinate, next_coordinate)
  return false if previous_coordinate.nil? || next_coordinate.nil?

  x_diff = (next_coordinate[0] - previous_coordinate[0]).abs
  y_diff = (next_coordinate[1] - previous_coordinate[1]).abs

  x_diff == 1 && y_diff == 1
end

def find_neighbors(map, coordinate)
  up = [coordinate[0], coordinate[1] - 1]
  right = [coordinate[0] + 1, coordinate[1]]
  down = [coordinate[0], coordinate[1] + 1]
  left = [coordinate[0] - 1, coordinate[1]]

  neighbors = []

  neighbors << up if up[1] >= 0 && map[up[1]][up[0]] != "#"
  neighbors << right if right[0] < X_MAX && map[right[1]][right[0]] != "#"
  neighbors << down if down[1] < Y_MAX && map[down[1]][down[0]] != "#"
  neighbors << left if left[0] >= 0 && map[left[1]][left[0]] != "#"

  neighbors
end

def build_graph(map)
  graph = Hash.new { |h, k| h[k] = [] }
  special_coordinates = {}

  map.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if char == "#"

      special_coordinates[char] = [x, y] if %w[S E].include?(char)
      graph[[x, y]] = find_neighbors(map, [x, y])
    end
  end

  { graph:, special_coordinates: }
end

time = Benchmark.realtime do
  build_graph(map) => { graph:, special_coordinates:}

  starting_position = special_coordinates["S"]
  ending_position = special_coordinates["E"]
  initial_direction = :east
  answer = solve_with_dijkstra(graph, starting_position, ending_position, initial_direction)
  path = reconstruct_path(answer[:distances], answer[:predecessors], ending_position)
  score = 0
  path.each_with_index do |(coordinate, direction), idx|
    thing_at_coordinate = map[coordinate[1]][coordinate[0]]
    label = DIRECTION_LABEL[direction]
    map[coordinate[1]][coordinate[0]] = label.colorize(COLORS[label]) unless %w[S
                                                                                E].include?(thing_at_coordinate)

    next_coordinate = path[idx + 1]&.first
    beginning_turning_vertical = next_coordinate && %i[east
                                                       west].include?(initial_direction) && (next_coordinate[1] - coordinate[1]) != 0
    beginning_turning_horizontal = next_coordinate && %i[north
                                                         south].include?(initial_direction) && (next_coordinate[0] - coordinate[0]) != 0

    if idx.zero? && (beginning_turning_vertical || beginning_turning_horizontal)
      # Special case
      score += 1000
    end

    previous_coordinate = path[idx - 1]&.first
    score += if changed_direction?(previous_coordinate, next_coordinate)
               1001
             else
               1
             end
  end
  # puts
  # print_map(map)

  score -= 1
  puts "Score: #{score}".green
end

puts "Time: #{time.round(2)}s".yellow
