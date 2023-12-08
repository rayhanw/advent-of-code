require 'colorized_string'
require_relative 'helpers'
require_relative '../../helpers/advent_of_code'

HANDS = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse.freeze

ANSWERS = [
254_057_872 # 1. Too high
].freeze

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
hands = []
file.each do |line|
  next if line.empty? || line.start_with?('#')

  hand = line.split(' ')
  hands << { hand: hand[0], bid: hand[1].to_i }
end

WINNINGS = %i[HIGH_CARD ONE_PAIR TWO_PAIR THREE_OF_A_KIND FULL_HOUSE FOUR_OF_A_KIND FIVE_OF_A_KIND].freeze
hand_groups = {
FIVE_OF_A_KIND: [],
FOUR_OF_A_KIND: [],
FULL_HOUSE: [],
THREE_OF_A_KIND: [],
TWO_PAIR: [],
ONE_PAIR: [],
HIGH_CARD: []
}
hand_groups_mod = {
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

hand_groups.each do |_type, hand_group|
  hand_group.each do |hand|
    js = hand[:hand].count('J')

    if js == 4 || js == 5
      hand[:type] = :FIVE_OF_A_KIND
      hand_groups_mod[:FIVE_OF_A_KIND] << hand
      next
    elsif js == 3 && hand[:hand].chars.uniq.size == 3
      hand[:type] = :FOUR_OF_A_KIND
      hand_groups_mod[:FOUR_OF_A_KIND] << hand
      next
    elsif js == 3 && hand[:hand].chars.uniq.size == 2
      hand[:type] = :FIVE_OF_A_KIND
      hand_groups_mod[:FIVE_OF_A_KIND] << hand
      next
    elsif js == 2
      if hand[:hand].chars.uniq.size == 2
        hand[:type] = :FIVE_OF_A_KIND
        hand_groups_mod[:FIVE_OF_A_KIND] << hand
      elsif hand[:hand].chars.uniq.size == 3
        hand[:type] = :FOUR_OF_A_KIND
        hand_groups_mod[:FOUR_OF_A_KIND] << hand
      elsif hand[:hand].chars.uniq.size == 4
        hand[:type] = :THREE_OF_A_KIND
        hand_groups_mod[:THREE_OF_A_KIND] << hand
      else
        hand[:type] = :FULL_HOUSE
        hand_groups_mod[:FULL_HOUSE] << hand
      end
    elsif js == 1
      if hand[:hand].chars.uniq.size == 2
        hand[:type] = :FIVE_OF_A_KIND
        hand_groups_mod[:FIVE_OF_A_KIND] << hand
      elsif hand[:hand].chars.uniq.size == 5
        hand[:type] = :ONE_PAIR
        hand_groups_mod[:ONE_PAIR] << hand
      elsif hand[:hand].chars.uniq.size == 4
        hand[:type] = :THREE_OF_A_KIND
        hand_groups_mod[:THREE_OF_A_KIND] << hand
      elsif hand[:hand].chars.uniq.size == 3
        haha = hand[:hand].chars
        haha.delete('J')
        if haha.count(haha[0]) == 2
          hand[:type] = :FULL_HOUSE
          hand_groups_mod[:FULL_HOUSE] << hand
        else
          hand[:type] = :FOUR_OF_A_KIND
          hand_groups_mod[:FOUR_OF_A_KIND] << hand
        end
      end
    else
      hand_groups_mod[hand[:type]] << hand
    end
  end
end

pp hand_groups_mod

hand_groups_mod.each do |score, hand_group|
  hand_groups_mod[score] = hand_group.sort_by { |hand| [HANDS.index(hand[:hand][0]), HANDS.index(hand[:hand][1]), HANDS.index(hand[:hand][2]), HANDS.index(hand[:hand][3]), HANDS.index(hand[:hand][4])] }
end

# Arrange
answers = [
*hand_groups_mod[:HIGH_CARD],
*hand_groups_mod[:ONE_PAIR],
*hand_groups_mod[:TWO_PAIR],
*hand_groups_mod[:THREE_OF_A_KIND],
*hand_groups_mod[:FULL_HOUSE],
*hand_groups_mod[:FOUR_OF_A_KIND],
*hand_groups_mod[:FIVE_OF_A_KIND]
]
puts '---------------------------------------------------------------'
sum = 0
answers.each_with_index do |hand, i|
  puts "#{hand[:hand]} {#{hand[:type]}} | #{ColorizedString["[$#{hand[:bid]}]"].colorize(:green)} #{hand[:bid]}*#{i + 1} | rank #{i + 1}"
  sum += hand[:bid] * (i + 1)
end

puts "ANSWER #{sum}"
