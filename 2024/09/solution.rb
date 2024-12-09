require 'benchmark'
require 'colorize'
require 'colorized_string'

FILE = File.readlines('input.txt').map(&:strip)[0]

time = Benchmark.measure do
  disk_map = FILE.each_char.map.with_index do |char, idx|
    amount = char.to_i
    if idx.even?
      (idx / 2).to_s * amount
    else
      '.' * amount
    end
  end

  disk_map = disk_map.join('')
  puts "Original: #{disk_map} | Length: #{disk_map.length}"
  reversed = disk_map.reverse.gsub('.', '').chars
  puts "Reversed: #{reversed.join('')}"
end

puts '---------------------------------------------'.colorize(:yellow)
puts time
