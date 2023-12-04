require 'colorized_string'
require 'benchmark'

file = File.readlines('input.txt').map(&:strip)
LENGTH = file.length
MAPPING = {}

def transform(map, round)
  map.compact.flat_map do |number|
    if number == round
      number
    else
      MAPPING[number]
    end
  end
end

def line_total(round)
  count = 0
  (round - 1).times do |i|
    drop = transform(MAPPING[i + 1], round)
    (round - 1).times do
      drop = transform(drop, round)
    end
    count += drop.flatten.count(round)
  end

  count + 1
end

m = Benchmark.measure do
  rounds = []
  file.first(LENGTH).each_with_index do |line, j|
    l = line.gsub(/Card\s+\d+:/, '')
    list = l.split('|')
    cards = list[0].strip
    combinations = list[1].strip
    cards = cards.split(' ').map(&:to_i)
    combinations = combinations.split(' ').map(&:to_i)
    winning_combinations = []
    cards.each do |card|
      winning_combinations << card if combinations.include?(card)
    end

    current_set = []
    winning_combinations.length.times do |i|
      current_set << i + j + 2
    end
    MAPPING[j + 1] = current_set
  end

  puts 'Mapping:'
  MAPPING.each do |id, set|
    puts "#{id} => #{set}"
    rounds << set
  end

  puts
  result = 0
  LENGTH.times do |i|
    result += line_total(i + 1)
    p result
  end

  puts ColorizedString["Result: #{result}"].colorize(:green)
end

puts "#{m.real.round(4)}s"
