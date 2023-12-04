require 'colorized_string'

file = File.readlines('input.txt').map(&:strip)

sets = []
file.each do |line|
  l = line.gsub(/Card\s+\d+:/, '')
  list = l.split('|')
  cards = list[0].strip
  combinations = list[1].strip
  winning_combinations = []
  cards = cards.split(' ').map(&:to_i)
  combinations = combinations.split(' ').map(&:to_i)
  cards.each do |card|
    if combinations.include?(card)
      winning_combinations << card
    end
  end
  sets << winning_combinations
end

factored = sets.select { |set| set.length.positive? }.map do |set|
  2**(set.length - 1)
end

puts "ANSWER: #{factored.sum}"
