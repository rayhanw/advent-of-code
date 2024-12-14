require 'benchmark'
require 'colorize'
require 'colorized_string'

FILE = File.readlines('input.txt').map(&:strip)
MODIFIER_CONSTANT = 10_000_000_000_000

def format_buttons_and_prize(group)
  button_a = group[0].split(': ')[1].split(', ')
  button_a = { x_increment: button_a[0].gsub('X+', '').to_i, y_increment: button_a[1].gsub('Y+', '').to_i }
  button_b = group[1].split(': ')[1].split(', ')
  button_b = { x_increment: button_b[0].gsub('X+', '').to_i, y_increment: button_b[1].gsub('Y+', '').to_i }
  prize = group[2].split(': ')[1].split(', ')
  prize = { x: prize[0].gsub('X=', '').to_i + MODIFIER_CONSTANT, y: prize[1].gsub('Y=', '').to_i + MODIFIER_CONSTANT }

  {
    button_a:,
    button_b:,
    prize:
  }
end

def solve(x_target, y_target, x_a, y_a, x_b, y_b)
  b = (y_target * x_a - y_a * x_target) / (x_a * y_b - x_b * y_a)
  a = (x_target - b * x_b) / x_a

  x_reached_target = x_a * a + x_b * b == x_target
  y_reached_target = y_a * a + y_b * b == y_target
  return 0 unless x_reached_target && y_reached_target

  a * 3 + b
end

time = Benchmark.measure do
  groups = FILE.slice_when { |_before, after| after.empty? }.map { |group| group.reject(&:empty?) }
  groups.map! { |group| format_buttons_and_prize(group) }

  answer = groups.sum do |group|
    button_a = group[:button_a]
    button_b = group[:button_b]
    prize = group[:prize]
    x0 = button_a[:x_increment]
    x1 = button_b[:x_increment]
    x_target = prize[:x]
    y0 = button_a[:y_increment]
    y1 = button_b[:y_increment]
    y_target = prize[:y]

    puts "Button A: X+#{group[:button_a][:x_increment]}, Y+#{group[:button_a][:y_increment]}".colorize(:cyan)
    puts "Button B: X+#{group[:button_b][:x_increment]}, Y+#{group[:button_b][:y_increment]}".colorize(:light_blue)
    puts "Prize: X=#{group[:prize][:x]}, Y=#{group[:prize][:y]}".colorize(:yellow)
    answer = solve(x_target, y_target, x0, y0, x1, y1)
    puts "Iteration: #{answer}".colorize(:green)

    puts
    answer
  end

  puts "Answer: #{answer}".colorize(:green)
end

puts
puts time

# P2: 158.236.882.779.913 -> Too high
# P2: 93.209.116.744.825 ✅
