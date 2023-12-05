require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))

map = [[0, 0]]
aoc.file.join("").chars.each do |char|
  coords = map.last.dup
  case char
  when '^'
    coords[1] += 1
  when 'v'
    coords[1] -= 1
  when '>'
    coords[0] += 1
  when '<'
    coords[0] -= 1
  end

  map << coords
end

puts "[P1] #{map.uniq.count} houses"

# -----------------------------------------------------------------------------
# Part 2
instructions = aoc.file.join('').chars
santa = instructions.filter.with_index { |_, i| i.even? }
robo_santa = instructions.filter.with_index { |_, i| i.odd? }
santa_map = [[0, 0]]
robo_santa_map = [[0, 0]]
santa.each do |ins|
  coords = santa_map.last.dup
  case ins
  when '^'
    coords[1] += 1
  when 'v'
    coords[1] -= 1
  when '>'
    coords[0] += 1
  when '<'
    coords[0] -= 1
  end

  santa_map << coords
end
robo_santa.each do |ins|
  coords = robo_santa_map.last.dup
  case ins
  when '^'
    coords[1] += 1
  when 'v'
    coords[1] -= 1
  when '>'
    coords[0] += 1
  when '<'
    coords[0] -= 1
  end

  robo_santa_map << coords
end

puts "[P2] #{(santa_map + robo_santa_map).uniq.count} houses"
