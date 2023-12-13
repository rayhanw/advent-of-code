require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
file.map! do |line|
  springs, conditions = line.split(' ')
  hints = conditions.split(',').map(&:to_i)
  question_marks = []
  springs.chars.each_with_index do |c, i|
    question_marks << i if c == '?'
  end

  groups = springs.split(/\.+/).reject(&:empty?)

  { springs:, hints:, question_marks:, groups:, possibilities: 0 }
end

file.each do |line|
  puts "Springs: #{line[:springs].chars.join(' ')}"
  puts "Hints: #{line[:hints]}"
  puts

  check_hot_spring(line[:springs], line[:hints])
end
