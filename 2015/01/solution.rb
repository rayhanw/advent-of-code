require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))

instructions = aoc.file[0].chars
up = instructions.count("(")
down = instructions.count(")")

puts "P1: #{up - down}"

# ------------------------------------------------------------------------------
# PART 2

floor = 0
instructions.each_with_index do |ins, i|
  if ins == "("
    floor += 1
  elsif ins == ")"
    floor -= 1
  end

  if floor == -1
    puts "P2: #{i + 1}"
    break
  end
end
