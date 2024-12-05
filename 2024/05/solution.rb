# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

FILE = File.readlines('input.txt').map(&:strip)
ordering_rules = []
update_instructions = []

FILE.each do |line|
  if line.include?("|")
    ordering_rules << line
  elsif line.include?(",")
    update_instructions << line
  end
end
update_instructions.map! { |instruction| instruction.split(",").reverse }

ordering_rules.each do |rule|
  # puts rule
end

puts "----------------"
rule_followers = []
rule_breakers = []
# For P1
update_instructions.each do |ins|
  combinations = ins.combination(2).to_a.map { |comb| comb.join("|") }
  unless combinations.any? { |pair| ordering_rules.include?(pair) }
    rule_followers << ins
  end
end

rule_followers.map! { |ele| ele.map(&:to_i) }
counter = rule_followers.sum do |hehe|
  hehe[(hehe.size / 2)]
end

# puts "Answer P1: #{counter}".colorize(:green)
# puts "-----------------------------"

# For P2
counter2 = 0
update_instructions.first(10).each_with_index do |instruction, idx|
  combinations = instruction.combination(2).to_a.map { |comb| comb.join("|") }
  broken_rules = combinations.select { |pair| ordering_rules.include?(pair) }
  next if broken_rules.empty?

  # puts "#{idx + 1178}: #{instruction.reverse.join(",")}"
  instruction_to_modify = [*instruction.reverse]
  # puts "broken_rules: #{broken_rules}"
  # puts
  broken_rules.reverse.each_with_index do |broken_rule, idx|
    broken_rule.split("|") => [first, second]
    first_index = instruction_to_modify.index(first)
    second_index = instruction_to_modify.index(second)
    if idx.positive?
      broken_rules2 = combinations.select { |pair| ordering_rules.include?(pair) }
      # puts "broken_rules2: #{broken_rules2}"
    end
    # puts "Before swap: #{instruction_to_modify}"
    instruction_to_modify[first_index], instruction_to_modify[second_index] = instruction_to_modify[second_index], instruction_to_modify[first_index]
    # puts "After swap: #{instruction_to_modify}\n\n"
  end

  puts "#{idx + 1178}: #{instruction_to_modify.join(",")}"
  counter2 += instruction_to_modify[instruction_to_modify.size / 2].to_i
end

puts "Answer P2: #{counter2}".colorize(:green)

# 6156 -> Too low
