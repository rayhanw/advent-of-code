require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)[0]

time = Benchmark.measure do
  disk_map = FILE.each_char.map.with_index do |char, idx|
    amount = char.to_i
    if idx.even?
      Array.new(amount) { (idx / 2) }
    else
      Array.new(amount) { "." }
    end
  end

  disk_map.flatten!
  reversed_disk_map = disk_map.reverse.join("")
  reversed_disk_map.chars.each_with_index do |char, idx|
    next if char == "."

    dot_index = disk_map.index(".")
    break unless (disk_map.size - 1 - idx) > dot_index

    disk_map[disk_map.size - 1 - idx] = "."
    disk_map[dot_index] = char
  end

  sums = disk_map.map.with_index do |char, idx|
    (idx * char.to_i)
  end

  # puts disk_map.join

  p sums.sum
end

puts "---------------------------------------------".colorize(:yellow)
puts time

# P1: 90_719_109_188 -> Too low
# P1: 6_173_215_867_211 -> Too low
