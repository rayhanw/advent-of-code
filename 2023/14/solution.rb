require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AoC.new(File.join(__dir__, 'input.txt'))
file = aoc.file.map(&:chars)
modified = []

file.each do |line|
  puts line.join(" ")
end
puts

file.transpose.each do |line|
  modified << bubble_sort(line)
end

puts ColorizedString['---- Transposed ----'].colorize(:red)
sum = 0
modified.transpose.each_with_index do |line, i|
  rock_amount = line.count('O')
  total = rock_amount * (modified.size - i)
  sum += total
end

puts ColorizedString["ANSWER: #{sum}"].colorize(:green)
