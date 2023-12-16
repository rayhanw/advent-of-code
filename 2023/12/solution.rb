require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

filepath = File.join(__dir__, ARGV[0] ? 'sample.txt' : 'input.txt')
aoc = Helpers::AdventOfCode.new(filepath)
file = aoc.file
file.map! do |line|
  springs, arrangement = line.split(' ')
  arrangement = arrangement.split(',').map(&:to_i)

  { springs:, arrangement: }
end

sum = file.sum do |line|
  springs = line[:springs]
  arrangement = line[:arrangement]
  # puts "#{springs}\t#{arrangement}"
  generate_combinations(springs, arrangement).size
end

puts ColorizedString["Answer: #{sum}"].colorize(color: :green, mode: :bold)
