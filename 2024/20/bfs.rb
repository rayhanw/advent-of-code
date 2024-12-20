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
MAGIC_NUMBER = 2
MIN_CHEAT_SECONDS = 100 + MAGIC_NUMBER

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

def bfs(graph, starting_point, ending_point)
  queue = [starting_point]
  visited = Set.new
  predecessors = {}

  until queue.empty?
    current = queue.shift
    return predecessors if current == ending_point

    # puts "Currently at: #{current}"
    visited.add(current)
    neighbors = graph[current]
    # puts " Exploring neighbors: #{neighbors}"
    neighbors.each do |neighbor|
      next if visited.include?(neighbor)

      predecessors[neighbor] = current
      queue << neighbor
    end
  end

  nil
end

# Backtrack from the target node to the source node
def reconstruct_path(predecessors, target)
  path = []
  current_node = target
  while current_node
    # Add the current node to the path
    path << current_node
    # Move to the next node in the path
    current_node = predecessors[current_node]
  end

  path.reverse
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

def find_cheatable_spots(map, coordinate, path_onwards, seconds_to_finish_original)
  x, y = coordinate
  cheatable_coords = []
  cheat_counter = Hash.new { |h, k| h[k] = 0 }
  counter = 0

  # Up
  up = [x, y - 1]
  up_of_up = [x, y - 2]
  up_of_up_is_upcoming = path_onwards.include?(up_of_up)
  up_is_wall = map[up[1]][up[0]] == "#"
  if up_of_up[1].positive? && up_of_up_is_upcoming && up_is_wall
    cheatable_coords << up
    counter += 1
    saved = path_onwards.index(up_of_up) + MIN_CHEAT_SECONDS - MAGIC_NUMBER
    cheat_counter[saved] += 1
    # puts "[U] #{saved} picoseconds saved."
  end

  # Down
  down = [x, y + 1]
  down_of_down = [x, y + 2]
  down_of_down_is_upcoming = path_onwards.include?(down_of_down)
  down_is_wall = map[down[1]][down[0]] == "#"
  if down_of_down[1] < Y_MAX && down_of_down_is_upcoming && down_is_wall
    cheatable_coords << down
    counter += 1
    saved = path_onwards.index(down_of_down) + MIN_CHEAT_SECONDS - MAGIC_NUMBER
    cheat_counter[saved] += 1
    # puts "[D] #{saved} picoseconds saved."
  end

  # Left
  left = [x - 1, y]
  left_of_left = [x - 2, y]
  left_of_left_is_upcoming = path_onwards.include?(left_of_left)
  left_is_wall = map[left[1]][left[0]] == "#"
  if left_of_left[0].positive? && left_of_left_is_upcoming && left_is_wall
    cheatable_coords << left
    counter += 1
    saved = path_onwards.index(left_of_left) + MIN_CHEAT_SECONDS - MAGIC_NUMBER
    cheat_counter[saved] += 1
    # puts "[L] #{saved} picoseconds saved."
  end

  # Right
  right = [x + 1, y]
  right_of_right = [x + 2, y]
  right_of_right_is_upcoming = path_onwards.include?(right_of_right)
  right_is_wall = map[right[1]][right[0]] == "#"
  if right_of_right[0] < X_MAX && right_of_right_is_upcoming && right_is_wall
    cheatable_coords << right
    counter += 1
    saved = path_onwards.index(right_of_right) + MIN_CHEAT_SECONDS - MAGIC_NUMBER
    cheat_counter[saved] += 1
    # puts "[R] #{saved} picoseconds saved."
  end

  { coordinates: cheatable_coords, counter:, cheat_counter: }
end

time = Benchmark.realtime do
  starting_point = nil
  ending_point = nil
  map = FILE.map(&:dup)
  dummy_map = FILE.map(&:dup)
  FILE.each_with_index do |row, y|
    row.each_with_index do |char, x|
      starting_point = [x, y] if char == "S"
      ending_point = [x, y] if char == "E"
    end
  end

  puts "Starting: #{starting_point}"
  puts "Ending: #{ending_point}"
  graph = build_graph(map)
  predecessors = bfs(graph, starting_point, ending_point)
  path = reconstruct_path(predecessors, ending_point)
  seconds_to_finish_original = path.size - 1
  path.each do |(x, y)|
    map[y][x] = "X" unless %w[S E].include?(map[y][x])
  end
  puts "----- Original map -----"
  # print_map(map)
  puts "Fastest original time: #{path.size - 1} picoseconds"
  puts

  outer_counter = 0
  path[1..(seconds_to_finish_original - MIN_CHEAT_SECONDS)].each do |(x, y)|
    path_onwards = path[(path.index([x, y]) + MIN_CHEAT_SECONDS)..]
    find_cheatable_spots(dummy_map, [x, y], path_onwards,
                         seconds_to_finish_original) => { coordinates:, counter:, cheat_counter: }
    if coordinates.any?
      # puts "Cheatable coordinates for #{[x, y]}"
      # puts " Cheating spots: #{cheating_coords}"
    end
    outer_counter += counter
    # dummy_map[y][x] = "X" unless %w[S E].include?(dummy_map[y][x])
  end
  # print_map(dummy_map)

  puts "Total cheatable coordinates: #{outer_counter}".colorize(:green)
end

puts
puts "Time: #{time.round(2)}s".colorize(:yellow)

# P1: 1541 (wrong)
# P1: 1542 (wrong)
