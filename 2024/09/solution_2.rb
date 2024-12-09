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

  disk_map.reject!(&:empty?)
  reversed_disk_map = disk_map.flatten.reverse.reject do |char|
    char == "."
  end.group_by { |char| char }.transform_values(&:size)

  # p reversed_disk_map
  # p disk_map

  # puts
  reversed_disk_map.each do |k, v|
    index_to_replace = disk_map.index { |row| row.all?(".") && row.count(".") >= v }

    unless index_to_replace
      # puts "Skipping #{k} => #{v}\n\n"
      next
    end

    dots = disk_map[index_to_replace].count(".")
    numbers = Array.new(v) { k }
    fillings = Array.new(dots - v) { "." }
    disk_map.delete_at(index_to_replace)
    disk_map.insert(index_to_replace, numbers)
    disk_map.insert(index_to_replace + 1, fillings) if fillings.any?
    index_to_replace_original = disk_map.rindex(numbers)
    disk_map[index_to_replace_original] = disk_map[index_to_replace_original].map { "." }
    # puts "IDR #{index_to_replace_original} | at #{disk_map[index_to_replace_original]}"
    # puts "New disk_map: #{disk_map.join.colorize(:yellow)}"
    # puts
  end

  sums = disk_map.flatten.map.with_index do |char, idx|
    (idx * char.to_i)
  end

  p sums.sum
end

puts "---------------------------------------------".colorize(:yellow)
puts time

# P1: 90_719_109_188 -> Too low
# P1: 6_173_215_867_211 -> Too low
# P1: 6_176_461_529_311 -> Too low
# P1: 6_176_461_048_143
# P1: 6_398_608_069_280
