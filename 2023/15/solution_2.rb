require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

name = ARGV[0]
path = File.join(__dir__, name ? 'sample.txt' : 'input.txt')
aoc = Helpers::AoC.new(path)
file = aoc.file[0].split(',')
boxes = Array.new(256) { [] }

=begin
Steps:
1. Determine the ASCII code for the current character of the string.
2. Increase the current value by the ASCII code you just determined.
3. Set the current value to itself multiplied by 17.
4. Set the current value to the remainder of dividing itself by 256.
=end

collection = []
file.each do |ins|
  line = ins.scan(/\w+/)
  text = line[0]
  value = ins.scan(/\d+/).flatten[0].to_i
  operation = ins.scan(/(=|-)/).flatten[0]

  collection << { box: determine_box(text), operation:, text:, value:, original: ins }
end

puts '----------------------------------------'

collection.each do |c|
  puts "After \"#{c[:original]}\""
  if c[:operation] == '='
    boxes[c[:box]] << c[:original]
  else
    stripped = strip_special_characters(c[:original])
    idx = lens_index(boxes, stripped)
    boxes[idx[:outer]].delete_at(idx[:inner]) if idx
  end
  print_boxes(boxes)
  puts
end

puts '---------------------------------------'

boxes.each_with_index do |box, i|
  next if box.empty?

  # puts "Box #{i}: #{box}"
end
