require_relative '../../helpers/advent_of_code'

name = ARGV[0]
path = File.join(__dir__, name ? 'sample.txt' : 'input.txt')
aoc = Helpers::AoC.new(path)
file = aoc.file[0].split(',')

=begin
Steps:
1. Determine the ASCII code for the current character of the string.
2. Increase the current value by the ASCII code you just determined.
3. Set the current value to itself multiplied by 17.
4. Set the current value to the remainder of dividing itself by 256.
=end

collection = []
file.each do |ins|
  iterator = 0
  puts "Running `#{ins}` with initial value of #{iterator}"
  ins.each_byte.with_index do |c, i|
    puts "`#{ins[i]}`"
    iterator += c
    puts "1. #{iterator}"
    iterator *= 17
    puts "2. #{iterator}"
    iterator %= 256
    puts "3. #{iterator}"
    puts
  end
  collection << iterator
  puts
end

p collection.sum
