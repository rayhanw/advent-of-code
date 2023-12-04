require 'colorized_string'

file = File.readlines('input.txt').map(&:strip)
LENGTH = file.length
MAPPING = {}

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

def hehe(map, round)
  map.compact.flat_map do |number|
    if number == round
      number
    else
      MAPPING[number]
    end
  end
end

def haha(round)
  drop_one = hehe(MAPPING[1], round)
  drop_one = hehe(drop_one, round)
  drop_one = hehe(drop_one, round)
  drop_one = hehe(drop_one, round)
  drop_one = hehe(drop_one, round)
  drop_one = hehe(drop_one, round)

  drop_two = hehe(MAPPING[2], round)
  drop_two = hehe(drop_two, round)
  drop_two = hehe(drop_two, round)
  drop_two = hehe(drop_two, round)
  drop_two = hehe(drop_two, round)
  drop_two = hehe(drop_two, round)

  drop_three = hehe(MAPPING[3], round)
  drop_three = hehe(drop_three, round)
  drop_three = hehe(drop_three, round)
  drop_three = hehe(drop_three, round)
  drop_three = hehe(drop_three, round)
  drop_three = hehe(drop_three, round)

  drop_four = hehe(MAPPING[4], round)
  drop_four = hehe(drop_four, round)
  drop_four = hehe(drop_four, round)
  drop_four = hehe(drop_four, round)
  drop_four = hehe(drop_four, round)
  drop_four = hehe(drop_four, round)

  drop_five = hehe(MAPPING[5], round)
  drop_five = hehe(drop_five, round)
  drop_five = hehe(drop_five, round)
  drop_five = hehe(drop_five, round)
  drop_five = hehe(drop_five, round)
  drop_five = hehe(drop_five, round)

  (drop_one + drop_two + drop_three + drop_four + drop_five).flatten.count(round) + 1
end

def improved_haha(round)
  count = 0
  (round - 1).times do |i|
    drop = hehe(MAPPING[i + 1], round)
    (round - 1).times do
      drop = hehe(drop, round)
    end
    count += drop.flatten.count(round)
  end

  count + 1
end

puts
result = 0
LENGTH.times do |i|
  result += improved_haha(i + 1)
end

puts ColorizedString["Result: #{result}"].colorize(:green)
