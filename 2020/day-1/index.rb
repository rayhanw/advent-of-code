require_relative 'numbers'

NUMBERS = STRING_NUMBERS.map(&:to_i)

combination_two = NUMBERS.combination(2).to_a
num_ary_two = combination_two.map { |ary| [ary.sum, ary] }.find { |ary| ary[0] == 2020 }[1]
answer_1 = num_ary_two.inject(:*)

puts 'ANSWER #1'
p answer_1

combination_three = NUMBERS.combination(3).to_a
num_ary_three = combination_three.map { |ary| [ary.sum, ary] }.find { |ary| ary[0] == 2020 }[1]
answer_2 = num_ary_three.inject(:*)

puts 'ANSWER #2'
p answer_2
