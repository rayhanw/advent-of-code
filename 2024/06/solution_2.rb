require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
X_MAX = FILE[0].length
Y_MAX = FILE.length
puts "Limits: X=#{X_MAX}, Y=#{Y_MAX}"
GUARD_FACE = {
  "^" => :up,
  "v" => :down,
  ">" => :right,
  "<" => :left
}.freeze
GUARD_TURN = {
  up: :right,
  right: :down,
  down: :left,
  left: :up
}.freeze

def determine_direction(char)
  GUARD_FACE[char]
end

def print_current_map(map)
  map.each_with_index do |line, idx|
    line.each_char do |char|
      color = if char == "."
                :white
              elsif char == "#"
                :red
              elsif char == "&"
                :magenta
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

  # puts "> Guard changed direction from #{direction} to #{guard_details[:direction]}"
end

def move!(map, guard_details, obstacles)
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
    obstacles << [x, y]
    change_direction!(guard_details)
    map[guard_details[:y]][guard_details[:x]] = GUARD_FACE.key(guard_details[:direction])
  else
    guard_details[:x] = x
    guard_details[:y] = y
    map[y][x] = GUARD_FACE.key(guard_details[:direction])
  end

  # puts "> Guard moved to (#{x}, #{y})"
end

def move_two!(map, starting_point, visited)
  start = { **starting_point }
  x = start[:x]
  y = start[:y]
  direction = start[:direction]

  if x.zero? || x == X_MAX - 1 || y.zero? || y == Y_MAX - 1
    # puts "Guard is at the edge of the map. Stopping the guard."
    return false
  end

  # Determine next coordinates to move to
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

  return true if visited.include?([x, y, direction])

  # Track where the guard movement
  visited.add([x, y, direction])

  # and & are the obstacles
  if map[y][x] == "#" || map[y][x] == "&"
    change_direction!(start)
    next_direction = GUARD_FACE.key(start[:direction])
    # puts "Obstacle detected at (#{x}, #{y}). Changing direction to #{GUARD_FACE[next_direction]}."
    map[start[:y]][start[:x]] = next_direction
  else
    start[:x] = x
    start[:y] = y
    # puts "Moving to (#{x}, #{y}). Direction: #{GUARD_FACE.key(start[:direction])}"
    map[y][x] = GUARD_FACE.key(start[:direction])
  end

  move_two!(map, start, visited)
end

def simulate_with_obstruction(map, starting_point)
  visited = Set.new([[starting_point[:x], starting_point[:y], starting_point[:direction]]])
  map[starting_point[:y]][starting_point[:x]] = GUARD_FACE.key(starting_point[:direction])
  # print_current_map(map)
  move_two!(map, starting_point, visited)
end

time = Benchmark.measure do
  guard_details = { x: 0, y: 0, direction: nil }
  starting_point = [nil, nil]
  FILE.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      if %w[^ v > <].include?(char)
        # puts "> Found Guard at (#{x}, #{y})"
        guard_details = { x:, y:, direction: determine_direction(char) }
        starting_point = { **guard_details }
        break
      end
    end
  end

  map = [*FILE]
  guard_paths = []
  obstacles = []

  loop do
    # 2. Mark the position of the guard with X
    map[guard_details[:y]][guard_details[:x]] = "X"
    guard_paths << [guard_details[:x], guard_details[:y]]
    # 3. Move the guard
    move!(map, guard_details, obstacles)
    # 4. Check if the guard is at the edge of the map
    is_at_edge = guard_details[:x].zero? || guard_details[:x] == X_MAX - 1 || guard_details[:y].zero? || guard_details[:y] == Y_MAX - 1
    # 5. Repeat until the guard is at the edge of the map
    next unless is_at_edge

    map[guard_details[:y]][guard_details[:x]] = "X"
    guard_paths << [guard_details[:x], guard_details[:y]]
    break
  end

  # puts "Guard Paths:".colorize(:yellow)
  guard_paths = guard_paths.uniq
  # p guard_paths
  # puts "-" * 60
  # puts "Obstacles".colorize(:light_red)
  obstacles = obstacles.uniq
  # p obstacles
  # puts "-" * 60
  starting_candidates = guard_paths.filter { |path| path != [starting_point[:x], starting_point[:y]] }
  candidates = Set.new(starting_candidates).to_a
  # puts "Candidates: #{candidates.size} potential".colorize(:light_blue)
  # p candidates
  new_candidates = []
  # puts "Starting Point: [#{starting_point[:x]}, #{starting_point[:y]}]. Facing `#{GUARD_FACE.key(starting_point[:direction])}` [#{starting_point[:direction]}]".colorize(:magenta)
  candidates.each do |candidate|
    # puts "Attempt: #{idx + 1}"
    dupe_map = map.map(&:dup)
    # puts "Obstructing at #{candidate}"
    dupe_map[candidate[1]][candidate[0]] = "&"
    # print_current_map(dupe_map)
    guard_looped = simulate_with_obstruction(dupe_map, starting_point)
    new_candidates << candidate if guard_looped
    # puts "-" * 21
  end

  puts "New Candidates: #{new_candidates.size} possibilities".colorize(:light_blue)
  # p new_candidates
end

puts time
