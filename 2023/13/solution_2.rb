require 'colorized_string'
require_relative 'helpers'
require_relative '../../helpers/advent_of_code'

ANSWERS = [
  47_849, # 1. Too high
  35_700, # 2. Too high
  16_692, # 3. Too low
].freeze

reflections = { rows: 0, columns: 0 }

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
patterns = file.slice_before(&:empty?).to_a.map { |group| group.reject(&:empty?) }

# patterns.each_with_index do |pattern, i|
#   puts ColorizedString["Pattern #{i + 1}"].colorize(:green)
#   pattern.each_with_index do |line, j|
#     puts "[#{j + 1}] #{line}"
#   end
#   puts
# end

patterns.each_with_index do |pattern, i|
  collection = []
  puts ColorizedString["Pattern #{i + 1}"].colorize(color: :light_blue, mode: :bold)
  count_reflection(pattern, :ROW, should_print: true, collection:, part: 2)
  count_reflection(pattern.map(&:chars).transpose.map(&:join), :COLUMN, should_print: true, collection:, part: 2)
  p collection
  first_reflection = collection.min_by { |col| col[:i] }
  if first_reflection
    puts "First reflection at #{first_reflection[:i]} on #{first_reflection[:type]}"
    key = first_reflection[:type] == :COLUMN ? :columns : :rows
    reflections[key] += first_reflection[:i]
  end
  puts '------------------------------'
end

puts
puts ColorizedString["Rows: #{reflections[:rows]}"].colorize(:green)
puts ColorizedString["Columns: #{reflections[:columns]}"].colorize(:green)
total = reflections[:rows] * 100 + reflections[:columns]
puts "Total: #{total}"
