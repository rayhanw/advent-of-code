require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)[0]

time = Benchmark.measure do
  disk_map = FILE.each_char.map.with_index do |char, idx|
    amount = char.to_i
    if idx.even?
      (idx / 2).to_s * amount
    else
      "." * amount
    end
  end.join("").chars

  counter = 0
  loop do
    # First available index of a dot
    index_of_dot = disk_map.index(".")
    # Take the last character
    last_char = disk_map[-1]
    # If the last character is a dot, keep popping until it's not
    until last_char != "."
      disk_map.pop
      last_char = disk_map[-1]
    end
    # Apply the last character to the first available index of a dot
    disk_map[index_of_dot] = last_char
    disk_map.pop
    counter += 1

    break if disk_map.count(".").zero?
  end

  sums = disk_map.map.with_index do |char, idx|
    (idx * char.to_i)
  end

  p sums.sum
end

puts "---------------------------------------------".colorize(:yellow)
puts time

# P1: 90719109188 -> Too low
