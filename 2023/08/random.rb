require 'colorized_string'
require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'drawing.txt'))
file = aoc.file
pp file.map { |line| line.gsub(/\w+ -> /, '') }.map(&:to_i).sort
