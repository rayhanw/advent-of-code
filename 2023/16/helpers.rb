MOVE_INDICATORS = %w[< > ^ v].freeze
ENCOUNTER_POSSIBILITIES = {
  '|' => {
    right: %i[up down],
    left: %i[up down],
    up: %i[up],
    down: %i[down]
  },
  '-' => {
    right: %i[right],
    left: %i[left],
    up: %i[right left],
    down: %i[right left]
  },
  '.' => {
    right: %i[right],
    left: %i[left],
    up: %i[up],
    down: %i[down]
  },
  '/' => {
    right: %i[up],
    left: %i[down],
    up: %i[right],
    down: %i[left]
  },
  '\\' => {
    right: %i[down],
    left: %i[up],
    up: %i[left],
    down: %i[right]
  }
}.freeze

def print_map(map)
  map.each do |line|
    line.each do |char|
      movement_char = char
      movement_char = ColorizedString[char].colorize(color: :green, mode: :bold) if MOVE_INDICATORS.include?(char)
      print movement_char
      print ' '
    end
    puts
  end
  puts '-------------------'
end
