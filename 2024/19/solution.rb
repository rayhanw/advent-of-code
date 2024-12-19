require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)

###
# Patterns:
# white (w)
# blue (u)
# black (b)
# red (r)
# green (g)
###

def can_be_made_with_regex?(design, regex_pattern)
  regex_pattern.match?(design)
end

time = Benchmark.realtime do
  patterns, _, *designs = FILE

  patterns = patterns.split(", ")
  puts "Available patterns: [#{patterns.join(', ')}]".colorize(:yellow)
  puts

  regex_pattern = /^(#{patterns.join('|')})+$/

  possible_designs = designs.sum do |design|
    is_possible = can_be_made_with_regex?(design, regex_pattern)
    puts "#{design} #{is_possible ? '🟢' : '🔴'}"
    is_possible ? 1 : 0
  end

  puts
  puts "Possible designs: #{possible_designs}".colorize(:green)
end

puts
puts "Time: #{time.round(2)}".colorize(:magenta)
