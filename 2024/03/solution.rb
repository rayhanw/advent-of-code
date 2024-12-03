require "colorize"
require "colorized_string"

file = File.readlines('input.txt').map(&:strip).reject(&:empty?).join("")

file.split("do") => [beginning, *rest]
beginning = beginning.scan(/mul\((?<first>\d+),(?<second>\d+)\)/)
beginning = beginning.sum do |match|
  match.map(&:to_i).reduce(:*)
end

answer = rest.filter { |match| match.start_with?("()") }.sum do |match|
  match.scan(/mul\((?<first>\d+),(?<second>\d+)\)/).sum do |pair|
    pair.map(&:to_i).reduce(:*)
  end
end

puts "Answer: #{beginning + answer}".colorize(:yellow)

# P1 27455865 -> Wrong
# P2 5831453 -> Wrong
