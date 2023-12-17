require 'colorized_string'
require 'English'
require_relative 'helpers'
require_relative 'beam'

# rubocop:disable Style/GlobalVars
$map = $DEFAULT_INPUT.map(&:chomp).map(&:chars)
history = Set.new
traversed_coordinates = [[0, 0]]

# print_map($map)

active_beams = [Beam.new(position: [0, 0], direction: ENCOUNTER_POSSIBILITIES[$map[0][0]][:right][0])]

until active_beams.empty?
  active_beams = active_beams.flat_map do |beam|
    move(beam, $map, history, traversed_coordinates)
  end
end
# rubocop:enable Style/GlobalVars

p traversed_coordinates
puts ColorizedString["Answer #{traversed_coordinates.uniq.size}"].colorize(color: :light_blue)
