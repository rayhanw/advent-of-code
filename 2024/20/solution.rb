require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip).map(&:chars)
X_MAX = FILE[0].size
Y_MAX = FILE.size
COLORS = {
  "S" => :yellow,
  "E" => :green,
  "#" => :red,
  "1" => :blue,
  "2" => :blue
}.freeze

PICOSECONDS_SAVED = Hash.new { |h, k| h[k] = 0 }

def build_graph(map)
  graph = {}

  map.each_with_index do |row, y|
    row.each_with_index do |char, x|
      next if char == "#"

      graph[[x, y]] = []
      graph[[x, y]] << [x + 1, y] if x + 1 < X_MAX && map[y][x + 1] != "#"
      graph[[x, y]] << [x - 1, y] if x - 1 >= 0 && map[y][x - 1] != "#"
      graph[[x, y]] << [x, y + 1] if y + 1 < Y_MAX && map[y + 1][x] != "#"
      graph[[x, y]] << [x, y - 1] if y - 1 >= 0 && map[y - 1][x] != "#"
    end
  end

  graph
end

def dijkstra(graph, source)
  distances = Hash.new(Float::INFINITY)
  distances[source] = 0
  priority_queue = [[source, 0]]
  predecessors = {}
  visited = Set.new

  until priority_queue.empty?
    current_node, current_distance = priority_queue.min_by { |_, distance| distance }
    priority_queue.delete([current_node, current_distance])

    next if visited.include?([current_node, current_distance])

    visited.add([current_node, current_distance])

    # puts "Currently at: #{current_node} at distance: #{current_distance}"
    neighbors = graph[current_node]
    # puts " Neighbors: #{neighbors}"
    neighbors.each do |neighbor|
      # puts "  Exploring #{neighbor}"
      tentative_distance = current_distance + 1 # 1 because it's unweighted

      next unless tentative_distance < distances[neighbor]

      distances[neighbor] = tentative_distance
      predecessors[neighbor] = current_node
      priority_queue << [neighbor, tentative_distance]
      # puts "   Finished exploring #{neighbor} at distance: #{tentative_distance}"
      # puts "Currently in queue: #{priority_queue}"
    end
  end

  { predecessors: }
end

# Backtrack from the target node to the source node
def reconstruct_path(predecessors, source, target)
  path = []
  current_node = target
  while current_node
    # Add the current node to the path
    path << current_node
    # Move to the next node in the path
    current_node = predecessors[current_node]
  end

  path
end

def print_map(map)
  map.each do |line|
    line.each do |char|
      color = COLORS[char] || :white
      print "#{char.colorize(color)} "
    end
    puts
  end
end

def build_cheatable_coordinates(map, obstacles, path)
  # Build a list of all the coordinates that can be cheated
  ### Cheating rules
  # - Must be next to each other
  # - Only makes sense to replace "#" with the cheat
  ### IDEA
  # - Ignore borders
  # - Given a coordinate of an obstacle, check its surroundings
  # - If a surrounding is also a wall,
  #  - Push these coordinates to `cheatable_coordinates` in the format of [[x1, y1], [x2, y]]
  # - Lastly, make the combination of coordinates unique
  ###
  cheatable_coordinates = Set.new
  path_without_start_and_end = path[1...-1]
  path_without_start_and_end.each_with_index do |(x, y), idx|
    visited = path_without_start_and_end[0...idx]
    up = [x, y - 1]
    up_of_up = [x, y - 2]
    up_is_visited = visited.include?(up_of_up)
    if up[1] != 0 && map[up[1]][up[0]] == "#" && !up_is_visited && map[up_of_up[1]][up_of_up[0]] != "#"
      cheatable_coordinates.add([[x, y],
                                 up])
    end

    down = [x, y + 1]
    down_of_down = [x, y + 2]
    down_is_visited = visited.include?(down_of_down)
    if down[1] != Y_MAX - 1 && map[down[1]][down[0]] == "#" && !down_is_visited && map[down_of_down[1]][down_of_down[0]] != "#"
      cheatable_coordinates.add([[x, y],
                                 down])
    end

    left = [x - 1, y]
    left_of_left = [x - 2, y]
    left_is_visited = visited.include?(left_of_left)
    if left[0] != 0 && map[left[1]][left[0]] == "#" && !left_is_visited && map[left_of_left[1]][left_of_left[0]] != "#"
      cheatable_coordinates.add([[x, y],
                                 left])
    end

    right = [x + 1, y]
    right_of_right = [x + 2, y]
    right_is_visited = visited.include?(right_of_right)
    if right[0] != X_MAX - 1 && map[right[1]][right[0]] == "#" && !right_is_visited && map[right_of_right[1]][right_of_right[0]] != "#"
      cheatable_coordinates.add([[x, y],
                                 right])
    end
  end

  cheatable_coordinates.to_a
end

time = Benchmark.realtime do
  starting_point = nil
  ending_point = nil
  obstacles = []
  map = FILE.map(&:dup)
  FILE.each_with_index do |row, y|
    row.each_with_index do |char, x|
      starting_point = [x, y] if char == "S"
      ending_point = [x, y] if char == "E"
      # Only add obstacles that are not on the border
      obstacles << [x, y] if char == "#" && y != 0 && y != Y_MAX - 1 && x != 0 && x != X_MAX - 1
    end
  end

  puts "Starting: #{starting_point}"
  puts "Ending: #{ending_point}"
  # Find inital duration without cheating
  graph = build_graph(map)
  dijkstra(graph, starting_point) => { predecessors: }
  path = reconstruct_path(predecessors, starting_point, ending_point)
  initial_duration = path.size - 1
  puts "Duration without cheating: #{initial_duration} picoseconds".colorize(:green)

  # Starting point of where the attempt will be made, including cheating
  cheatable_coordinates = build_cheatable_coordinates(map, obstacles, path.reverse)
  puts "Cheatable count: #{cheatable_coordinates.size}"
  # puts "--- ORIGINAL MAP ---"
  # print_map(map)
  # puts "--- MAP w/ CHEAT COORDINATES ---"
  cheatable_coordinates.each do |(coord1, coord2)|
    dupe_map = map.map(&:dup)
    dupe_map[coord1[1]][coord1[0]] = "1"
    dupe_map[coord2[1]][coord2[0]] = "2"
    # puts "Cheating on: #{coord1} & #{coord2}"
    # print_map(dupe_map)
    graph = build_graph(dupe_map)
    dijkstra(graph, starting_point) => { predecessors: }
    path = reconstruct_path(predecessors, starting_point, ending_point)
    duration = path.size - 1
    duration_saved = initial_duration - duration
    # path.each do |(x, y)|
    #   dupe_map[y][x] = "X" if dupe_map[y][x] == "."
    # end
    # puts
    # print_map(dupe_map)
    if duration != initial_duration
      PICOSECONDS_SAVED[duration_saved] += 1
      # puts "Saved #{duration_saved.to_s.colorize(duration_saved == 4 ? :green : :white)} picoseconds".colorize(mode: :bold)
    end

    # puts
  end

  puts
  total_cheats_above_100 = PICOSECONDS_SAVED.each.to_a.sort_by do |duration, _amount|
    duration
  end.sum do |duration, amount|
    puts "There #{amount == 1 ? 'is one' : "are #{amount}"} #{amount > 1 ? 'cheats' : 'cheat'} that save #{duration} picoseconds.".colorize(:green)

    amount
  end

  puts "Total cheats that save more than 100 picoseconds: #{total_cheats_above_100}".colorize(:green)
end

puts
puts "Time: #{time.round(2)}s".colorize(:yellow)
