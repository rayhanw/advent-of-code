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
  # line_str = line.join("")
  # rock_amount = line_str.count("O")
  # dot_amount = line_str.count(".")
  # cube_amount = line_str.count("#")
  # total = rock_amount + dot_amount + cube_amount
  # puts line.join("")
  # puts ColorizedString["O: #{rock_amount}"].colorize(:green)
  # puts ColorizedString[".: #{dot_amount}"].colorize(:blue)
  # puts ColorizedString["#: #{cube_amount}"].colorize(:cyan)
  # puts "Total: #{total}"

  modified << bubble_sort(line)
  # index = 0
  # until collection.size == line.size
  #   current = line[index]
  #   collection << 'x'
  #   index += 1
  # end
end

puts ColorizedString['---- Transposed ----'].colorize(:red)
sum = 0
modified.transpose.each_with_index do |line, i|
  rock_amount = line.count('O')
  total = rock_amount * (modified.size - i)
  puts "#{rock_amount}*#{modified.size - i}=#{total}"
  sum += total
end

puts ColorizedString["ANSWER: #{sum}"].colorize(:green)
