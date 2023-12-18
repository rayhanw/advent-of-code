require 'colorized_string'
require 'English'
require_relative 'state'
require_relative 'helpers'

ANSWERS = [
  82, # 1. Wrong
].freeze

grid = $DEFAULT_INPUT.map(&:chomp).map(&:chars).map { |l| l.map(&:to_i) }
X_MAX_INDEX = grid.first.size - 1
Y_MAX_INDEX = grid.size - 1

# grid.each do |line|
#   puts line.join(' ')
# end

def find_min_heat_loss(grid)
  start_state = State.new(position: [0, 0], direction: :right, heat_loss: 0, steps: 0)
  # Priority queue or similar structure to explore states
  priority_queue = [start_state]
  visited = Set.new
  min_heat_loss = Float::INFINITY
  # Logic to explore all paths and find the minimum heat loss
  i = 1
  until priority_queue.empty?
    # puts "Step #{i}"
    i += 1
    # 1a
    priority_queue.sort_by!(&:heat_loss)
    # 2a
    current_state = priority_queue.shift

    # 4b
    if current_state.position[0] == X_MAX_INDEX && current_state.position[1] == Y_MAX_INDEX
      min_heat_loss = [min_heat_loss, current_state.heat_loss].min
      break
    end

    # 3b
    next if visited.include?([current_state.position, current_state.direction, current_state.steps])

    # 3a
    visited.add([current_state.position, current_state.direction, current_state.steps])

    # 2b
    possible_moves(current_state, grid, max_steps: 9, part: 2).each do |next_state|
      priority_queue.push(next_state)
    end
  end

  min_heat_loss
end

puts find_min_heat_loss(grid)
