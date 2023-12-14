require 'colorized_string'
require_relative 'helpers'
require_relative '../../helpers/advent_of_code'

ANSWERS = [
  36_107, # 1. Too low
].freeze

reflections = { rows: 0, columns: 0 }

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
patterns = file.slice_before(&:empty?).to_a.map { |group| group.reject(&:empty?) }

patterns.each_with_index do |pattern, i|
  puts ColorizedString["Pattern #{i + 1}"].colorize(:green)
  pattern.each_with_index do |line, j|
    puts "[#{j + 1}] #{line}"
  end
  puts
end

patterns.each do |pattern|
  # puts ColorizedString["OG Pattern:"].colorize(color: :light_blue, mode: :bold)
  # puts pattern.join("\n")

  # Check for reflection in row level
  collection = []
  reflections[:rows] += count_reflection(pattern, :ROW, collection:, part: 1)
  reflections[:columns] += count_reflection(pattern.map(&:chars).transpose.map(&:join), :COLUMN, collection:, part: 1)
  puts
end

puts ColorizedString["Rows: #{reflections[:rows]}"].colorize(:green)
puts ColorizedString["Columns: #{reflections[:columns]}"].colorize(:green)
total = reflections[:rows] * 100 + reflections[:columns]
puts "Total: #{total}"
