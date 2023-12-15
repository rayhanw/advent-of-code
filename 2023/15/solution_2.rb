require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

ANSWERS = [
  251_925, # 1. Too high
].freeze

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
  puts "After \"#{c[:original]}\":"
  if c[:operation] == '='
    idx = c[:box]
    cleaned_list = boxes[idx].map { |x| strip_special_characters(x).gsub(/\d+/, '') }
    stripped = strip_special_characters(c[:original]).gsub(/\d+/, '')
    stripped_idx = cleaned_list.index(stripped)

    if cleaned_list.include?(stripped)
      boxes[idx][stripped_idx] = c[:original]
    else
      boxes[idx] << c[:original]
    end
  else
    stripped = strip_special_characters(c[:original])
    idx = lens_index(boxes, stripped)
    boxes[idx[:outer]].delete_at(idx[:inner]) if idx
  end
  print_boxes(boxes)
  puts
end

puts '---------------------------------------'
collections = []
boxes.each_with_index do |box, i|
  next if box.empty?

  sum = 0
  box.each_with_index do |item, j|
    label, value = item.split('=')
    value = value.to_i
    total = (i + 1) * (j + 1) * value
    sum += total
    puts "- #{label}: `#{i + 1}` (box #{i}) * #{j + 1} * #{value} = #{total}"
  end
  collections << sum
end

puts ColorizedString["Answer: #{collections.sum}"].colorize(:green)
