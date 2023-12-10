require 'colorized_string'

POSSIBILITIES = {
  '|' => %w[N S],
  '-' => %w[E W],
  'L' => %w[N E],
  'J' => %w[N W],
  '7' => %w[S W],
  'F' => %w[S E],
  'S' => %w[N S E W]
}.freeze
ENTRYPOINTS = [
  'N',
  'S',
  'W',
  'E'
].freeze

###
# Formula moves:
# N: [y - 1, x]
# S: [y + 1, x]
# E: [y, x + 1]
# W: [y, x - 1]
###

def get_possible_directions(coords, file, starting_coordinates)
  char = file[coords[0]][coords[1]]
  direction = nil
  if starting_coordinates[0] - coords[0] == -1
    # Moving downwards
    direction = 'N'
  elsif starting_coordinates[0] - coords[0] == 1
    # Moving upwards
    direction = 'S'
  elsif starting_coordinates[1] - coords[1] == -1
    # Moving right
    direction = 'W'
  elsif starting_coordinates[1] - coords[1] == 1
    # Moving left
    direction = 'E'
  end
  { possibilities: POSSIBILITIES[char], direction:, coords: }
end

def get_possible_coordinates(char_coords, file)
  char = file[char_coords[0]][char_coords[1]]
  return nil unless POSSIBILITIES.key?(char)

  possibilities = []
  POSSIBILITIES[char].each do |direction|
    if direction == 'N'
      possibilities << [char_coords[0] - 1, char_coords[1]]
    elsif direction == 'S'
      possibilities << [char_coords[0] + 1, char_coords[1]]
    elsif direction == 'E'
      possibilities << [char_coords[0], char_coords[1] + 1]
    elsif direction == 'W'
      possibilities << [char_coords[0], char_coords[1] - 1]
    end
  end

  possibilities.filter { |coordinate| file[coordinate[0]][coordinate[1]] != '.' }.reject { |coordinate| coordinate.any?(&:negative?) }
end

def modify_map!(map, coordinate, label)
  map[coordinate[0]][coordinate[1]] = label.to_s
end

def print_map(map)
  puts ColorizedString["*** Map ***"].colorize(:green)
  map.each do |line|
    line.each do |char|
      data = char.match?(/\d+/) && char != '7' ? ColorizedString[char].colorize(:red) : char
      print data
      print ' '
    end
    puts
  end
end
