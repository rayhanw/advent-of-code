require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

CYCLE_COUNT = 1_000_000_000

aoc = Helpers::AoC.new(File.join(__dir__, 'input.txt'))
file = aoc.file.map(&:chars)

puts ColorizedString['---- Original ----'].colorize(:cyan)
file.each do |line|
  puts line.join(" ")
end
# --- Start cycle --- #
# North movement
puts ColorizedString['----- North ------'].colorize(:cyan)
file = file.transpose.map { |line| bubble_sort(line) }.transpose
file.each do |line|
  puts line.join(' ')
end

# West movement
puts ColorizedString['------ West -------'].colorize(:cyan)
file = file.transpose.reverse.map { |line| bubble_sort(line) }.transpose
file.each do |line|
  puts line.join(' ')
end

# South movement
puts ColorizedString['------ South ------'].colorize(:cyan)
# East movement
puts ColorizedString['------ East -------'].colorize(:cyan)
# --- End cycle --- #
