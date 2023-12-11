require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

ANSWERS = [
  12_799_216, # 1. Too low
  406_725_732_046 # 2. Correct
].freeze

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file.map(&:chars)

print_space(file)
puts "Rows: #{file.length}"
puts "Cols: #{file[0].length}"

empty_index_lines = { rows: [], columns: [] }

# Store index of empty rows
file.each_with_index do |row, i|
  empty_index_lines[:rows] << i if row.all? { |char| char == '.' }
end

# Store index of empty columns
file.transpose.each_with_index do |column, i|
  empty_index_lines[:columns] << i if column.all? { |char| char == '.' }
end

counter = 1
file.each_with_index do |rows, row|
  rows.each_with_index do |char, col|
    if char == '#'
      file[row][col] = counter.to_s
      counter += 1
    end
  end
end

galaxies = file.flatten.count { |char| char.match?(/\d+/) }
pairings = {}
# 1. Find all pairs of galaxies
(1..galaxies).each do |galaxy|
  galaxy_x = file.index { |row| row.include?(galaxy.to_s) }
  galaxy_y = file[galaxy_x].index(galaxy.to_s)
  (galaxy+1..galaxies).each do |pair|
    pair_x = file.index { |row| row.include?(pair.to_s) }
    pair_y = file[pair_x].index(pair.to_s)
    x_range = ([galaxy_x, pair_x].min..[galaxy_x, pair_x].max)
    y_range = ([galaxy_y, pair_y].min..[galaxy_y, pair_y].max)
    empty_rows_count = empty_index_lines[:rows].count { |index| x_range.cover?(index) }
    empty_cols_count = empty_index_lines[:columns].count { |index| y_range.cover?(index) }
    pairings["#{galaxy}-#{pair}"] = ((pair_x - galaxy_x).abs + (pair_y - galaxy_y).abs) + (empty_rows_count + empty_cols_count) * (1_000_000 - 1)
  end
end

puts "Sum: #{pairings.values.sum}"
# 2. Sum the path lengths
