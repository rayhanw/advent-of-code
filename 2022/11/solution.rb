require 'colorized_string'
require_relative 'helpers'

file = File.readlines("input.txt").map(&:strip)
lines = file.each_slice(7).to_a
lines.map! { |monkey| monkey.reject { |m| m == "" } }

monkeys = []

lines.each do |line|
  no = line[0].match(/Monkey\s+(?<number>\d+):/)[:number]

  line[1].gsub!('Starting items: ', '')
  items = line[1].split(', ').map(&:to_i)

  op = line[2].match(/Operation: new = old (?<op>(.{1})) (?<number>\w+)/)
  operation = { op: op[:op], number: op[:number] }

  test = line[3].match(/Test: divisible by (?<number>\d+)/)[:number].to_i

  test_y = line[4].match(/If true: throw to monkey (?<monkey>\d+)/)[:monkey].to_i
  test_n = line[5].match(/If false: throw to monkey (?<monkey>\d+)/)[:monkey].to_i

  monkey = {
    no: no.to_i,
    items:,
    operation:,
    test:,
    test_y:,
    test_n:,
    inspect_count: 0
  }
  monkeys.push(monkey)
end

print_situation(monkeys)
run_loop(monkeys, 10_000, 2)

puts
monkeys.each do |monkey|
  puts "Monkey #{monkey[:no]}: #{monkey[:items].join(', ')}"
end

monkeys.each do |monkey|
  puts "Monkey #{monkey[:no]} inspected items #{monkey[:inspect_count]} times."
end

active_monkeys = monkeys.sort_by { |monkey| -monkey[:inspect_count] }[0..1]
puts ColorizedString["ANSWER: #{active_monkeys[0][:inspect_count] * active_monkeys[1][:inspect_count]}"].colorize(color: :blue, mode: :bold)
