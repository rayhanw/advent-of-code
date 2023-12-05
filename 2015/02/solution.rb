require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))

total_area = 0
wraps = []
aoc.file.each do |line|
  match = line.match(/(?<l>\d+)x(?<w>\d+)x(?<h>\d+)/)
  wraps << { length: match[:l].to_i, width: match[:w].to_i, height: match[:h].to_i }
end

wraps.each do |wrap|
  # A = 2*l*w + 2*w*h + 2*h*l
  lw = wrap[:length] * wrap[:width]
  wh = wrap[:width] * wrap[:height]
  hl = wrap[:height] * wrap[:length]
  smallest = lw
  smallest = wh if wh < smallest
  smallest = hl if hl < smallest
  area = (2 * wrap[:length] * wrap[:width]) + (2 * wrap[:width] * wrap[:height]) + (2 * wrap[:height] * wrap[:length]) + smallest
  total_area += area
end

puts
puts "[P1] Total area: #{total_area}"

# -----------------------------------------------------------------------------
# Part 2

total = wraps.sum do |wrap|
  sides = wrap.values.sort
  ribbon = sides[0] * 2 + sides[1] * 2
  present = wrap.values.inject(:*)
  puts "Ribbon: #{ribbon} (#{present}) [#{ribbon + present}]"
  ribbon + present
end

puts "[P2] Total #{total}"
