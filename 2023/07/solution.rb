require 'colorized_string'
require_relative 'helpers'
require_relative '../../helpers/advent_of_code'

ATTEMPTS = [
  253_572_208, # 1. WRONG
  253_898_949, # 2. Too high
  253_638_572, # 3. WRONG
  254_022_014, # 4. WRONG
  253_694_816, # 5. WRONG
  253_603_890 # 6. GOOD STUFF
].freeze

HANDS = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.freeze

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
hands = []
file.each do |line|
  hand = line.split(' ')
  hands << { hand: hand[0], bid: hand[1].to_i }
end

hand_groups = {
  FIVE_OF_A_KIND: [],
  FOUR_OF_A_KIND: [],
  FULL_HOUSE: [],
  THREE_OF_A_KIND: [],
  TWO_PAIR: [],
  ONE_PAIR: [],
  HIGH_CARD: []
}

hands.each do |hand|
  card = hand[:hand].chars
  hand_count = card.uniq.count
  if hand_count == 4
    hand[:highest] = hand[:hand].chars.tally.max_by { |_, v| v }[0]
    hand[:type] = :ONE_PAIR
    hand_groups[:ONE_PAIR] << hand
  elsif hand_count == 3
    specifics = card.uniq.map { |c| card.count(c) }
    hand[:highest] = hand[:hand].chars.tally.max_by { |_, v| v }[0]
    if specifics.include?(3)
      hand[:type] = :THREE_OF_A_KIND
      hand_groups[:THREE_OF_A_KIND] << hand
    else
      hand[:type] = :TWO_PAIR
      hand_groups[:TWO_PAIR] << hand
    end
  elsif hand_count == 2
    specifics = card.uniq.map { |c| card.count(c) }
    if specifics.include?(4)
      hand[:type] = :FOUR_OF_A_KIND
      hand[:highest] = hand[:hand].chars.tally.max_by { |_, v| v }[0]
      hand_groups[:FOUR_OF_A_KIND] << hand
    else
      hand[:type] = :FULL_HOUSE
      hand_groups[:FULL_HOUSE] << hand
    end
  elsif hand_count == 1
    hand[:type] = :FIVE_OF_A_KIND
    hand[:highest] = hand[:hand].chars.tally.max_by { |_, v| v }[0]
    hand_groups[:FIVE_OF_A_KIND] << hand
  else
    hand[:type] = :HIGH_CARD
    hand_groups[:HIGH_CARD] << hand
  end
end

hand_groups.each do |score, hand_group|
  hand_groups[score] = hand_group.sort_by { |hand| [HANDS.index(hand[:hand][0]), HANDS.index(hand[:hand][1]), HANDS.index(hand[:hand][2]), HANDS.index(hand[:hand][3]), HANDS.index(hand[:hand][4])] }
end

# Arrange
answers = [
  *hand_groups[:HIGH_CARD],
  *hand_groups[:ONE_PAIR],
  *hand_groups[:TWO_PAIR],
  *hand_groups[:THREE_OF_A_KIND],
  *hand_groups[:FULL_HOUSE],
  *hand_groups[:FOUR_OF_A_KIND],
  *hand_groups[:FIVE_OF_A_KIND]
]
puts '---------------------------------------------------------------'
sum = 0
answers.each_with_index do |hand, i|
  puts "#{hand[:hand]} {#{hand[:type]}} | #{ColorizedString["[$#{hand[:bid]}]"].colorize(:green)} #{hand[:bid]}*#{i + 1} | rank #{i + 1}"
  sum += hand[:bid] * (i + 1)
end

puts "ANSWER #{sum}"
