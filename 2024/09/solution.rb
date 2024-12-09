require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)

time = Benchmark.measure do
  p FILE
end

puts "---------------------------------------------".colorize(:yellow)
puts time
