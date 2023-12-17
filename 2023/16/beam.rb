class Beam
  attr_accessor :position, :direction

  def initialize(position:, direction:)
    @position = position
    @direction = direction
  end
end

def move(beam, grid, history, traversed_coordinates)
  x, y = beam.position
  direction = beam.direction
  new_positions = []


  # Calculate new position based on direction
  new_x, new_y = calculate_new_position([x, y], beam.direction)
  return new_positions if new_y.negative? || new_x.negative? || new_y > grid.length - 1 || new_x > grid[0].length - 1

  # Check if the new position is within bounds
  history_key = [new_x, new_y, direction]
  unless history.include?(history_key)
    traversed_coordinates << [new_x, new_y]
    history.add(history_key)
    current_object = grid[new_y][new_x]
    new_directions = ENCOUNTER_POSSIBILITIES[current_object][direction]

    new_directions.each do |direction|
      new_positions << Beam.new(position: [new_x, new_y], direction:)
    end
  end

  new_positions
end

def calculate_new_position(position, direction)
  x, y = position
  case direction
  when :right
    [x + 1, y]
  when :left
    [x - 1, y]
  when :up
    [x, y - 1]
  when :down
    [x, y + 1]
  end
end
