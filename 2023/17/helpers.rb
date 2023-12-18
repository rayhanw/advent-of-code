OPPOSITE_DIRECTION = {
  up: :down,
  down: :up,
  left: :right,
  right: :left
}.freeze
DIRECTIONS = %i[up down left right].freeze

def calculate_new_position(position, direction)
  x, y = [*position]
  case direction
  when :up
    y -= 1
  when :down
    y += 1
  when :left
    x -= 1
  when :right
    x += 1
  end

  [x, y]
end

def calculate_heat_loss(state, grid, new_position)
  x, y = new_position
  # Add the heat loss for the current position unless it's the start position
  additional_heat_loss = (x.zero? && y.zero? ? 0 : grid[y][x])
  state.heat_loss + additional_heat_loss
end

def possible_moves(state, grid, max_steps: 3, part: 1)
  # Logic to determine the next possible moves based on the current state
  # Make sure to consider the constraints of the problem
  x, y = state.position
  current_direction = state.direction
  steps_taken = state.steps
  possible_states = []
  possible_directions = DIRECTIONS - [OPPOSITE_DIRECTION[current_direction]]
  if steps_taken < 4
    possible_directions = [current_direction]
  end
  p "Going #{current_direction} from [#{x}, #{y}] for #{steps_taken}"
  p possible_directions
  puts
  possible_directions.each do |direction|
    next if direction == current_direction && steps_taken >= max_steps

    new_x, new_y = calculate_new_position([x, y], direction)

    # Check if the new position is within the grid boundaries
    next unless new_x.between?(0, grid[0].length - 1) && new_y.between?(0, grid.length - 1)

    new_heat_loss = calculate_heat_loss(state, grid, [new_x, new_y])
    new_steps = direction == current_direction ? steps_taken + 1 : 1
    possible_states << State.new(
      position: [new_x, new_y],
      direction:,
      heat_loss: new_heat_loss,
      steps: new_steps
    )
  end

  possible_states
end
