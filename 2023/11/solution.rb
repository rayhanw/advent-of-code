require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file.map(&:chars)

print_space(file)
puts "Rows: #{file.length}"
puts "Cols: #{file[0].length}"

empty_index_lines = { rows: [], columns: [] }

# Store index of empty rows
file.each_with_index do |row, i|
  if row.all? { |char| char == '.' }
    empty_index_lines[:rows] << i
  end
end

# Store index of empty columns
file.transpose.each_with_index do |column, i|
  if column.all? { |char| char == '.' }
    empty_index_lines[:columns] << i
  end
end

# Add empty N columns at each empty row
empty_index_lines[:rows].reverse.each do |index|
  file.insert(index, Array.new(file[0].length, '.'))
end

# Add empty N rows at each empty column
empty_index_lines[:columns].reverse.each do |index|
  file.each do |row|
    row.insert(index, '.')
  end
end

# print_space(file)
# puts "Rows: #{file.length}"
# puts "Cols: #{file[0].length}"

counter = 1
file.each_with_index do |rows, row|
  rows.each_with_index do |char, col|
    if char == '#'
      file[row][col] = counter.to_s
      counter += 1
    end
  end
end

print_space(file)

galaxies = file.flatten.count { |char| char.match?(/\d+/) }
pair_count = Array.new(galaxies - 1) { |i| i + 1 }.sum
puts "🪐: #{galaxies}"
puts "🌌: #{pair_count}"

pairings = {}
# 1. Find all pairs of galaxies
(1..galaxies).each do |galaxy|
  puts "Galaxy #{galaxy}"
  galaxy_x = file.index { |row| row.include?(galaxy.to_s) }
  galaxy_y = file[galaxy_x].index(galaxy.to_s)
  (galaxy+1..galaxies).each do |pair|
    pair_x = file.index { |row| row.include?(pair.to_s) }
    pair_y = file[pair_x].index(pair.to_s)
    puts "Pair  #{pair}"
    puts "Mapping  #{galaxy_x},#{galaxy_y} -> #{pair_x},#{pair_y}"
    puts "Diff  #{pair_x - galaxy_x},#{pair_y - galaxy_y}"
    puts "AbsDiff  #{(pair_x - galaxy_x).abs + (pair_y - galaxy_y).abs}"
    puts "  ---"
    pairings["#{galaxy}-#{pair}"] = (pair_x - galaxy_x).abs + (pair_y - galaxy_y).abs
  end
  puts "---"
end
puts "Sum #{pairings.values.sum}"
# 2. Sum the path lengths
