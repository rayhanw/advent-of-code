require 'benchmark'
require 'colorize'
require 'colorized_string'

FILE = File.readlines('input.txt').map(&:strip)

def format_buttons_and_prize(group)
  button_a = group[0].split(': ')[1].split(', ')
  button_a = { x_increment: button_a[0].gsub('X+', '').to_i, y_increment: button_a[1].gsub('Y+', '').to_i }
  button_b = group[1].split(': ')[1].split(', ')
  button_b = { x_increment: button_b[0].gsub('X+', '').to_i, y_increment: button_b[1].gsub('Y+', '').to_i }
  prize = group[2].split(': ')[1].split(', ')
  prize = { x: prize[0].gsub('X=', '').to_i, y: prize[1].gsub('Y=', '').to_i }

  {
    button_a:,
    button_b:,
    prize:
  }
end

time = Benchmark.measure do
  # Your code here
  groups = FILE.slice_when { |_before, after| after.empty? }.map { |group| group.reject(&:empty?) }
  groups.map! { |group| format_buttons_and_prize(group) }

  possibles = groups.map do |group|
    x_possibilities = []
    y_possibilities = []
    # puts "Button A: X+#{group[:button_a][:x_increment]}, Y+#{group[:button_a][:y_increment]}".colorize(:cyan)
    # puts "Button B: X+#{group[:button_b][:x_increment]}, Y+#{group[:button_b][:y_increment]}".colorize(:light_blue)
    # puts "Prize: X=#{group[:prize][:x]}, Y=#{group[:prize][:y]}".colorize(:yellow)

    button_a = group[:button_a]
    button_b = group[:button_b]
    prize = group[:prize]
    x0 = button_a[:x_increment]
    x1 = button_b[:x_increment]
    x_target = prize[:x]
    # puts "X Equation: #{x0}a + #{x1}b = #{x_target}".colorize(:green)
    highest_possible_b = x_target / x1
    # puts "  Highest possible b: #{highest_possible_b}".colorize(:green)
    lowest_possible_x = { a: nil, b: nil }
    (highest_possible_b + 1).times do |b|
      a = (x_target - (x1 * b)) / x0
      can_equal_to_target = a * x0 + b * x1 == x_target
      puts "a: #{a} | b: #{b} | Step a: -#{x1 / x0.gcd(x1)} | Step b: #{x0 / x0.gcd(x1)} | FPB: #{x0.gcd(x1)} | Equation: #{x0}a + #{x1}b = #{x_target}".colorize(:light_magenta)
      if can_equal_to_target
        lowest_possible_x = { a:, b: }
        # break
      end
      x_possibilities << { a: a, b: b } if can_equal_to_target
    end

    y0 = button_a[:y_increment]
    y1 = button_b[:y_increment]
    y_target = prize[:y]
    # puts "Y Equation: #{y0}a + #{y1}b = #{y_target}".colorize(:green)
    highest_possible_b = y_target / y1
    # puts "  Highest possible b: #{highest_possible_b}".colorize(:green)
    lowest_possible_y = { a: nil, b: nil }
    (highest_possible_b + 1).times do |b|
      a = (y_target - (y1 * b)) / y0
      can_equal_to_target = a * y0 + b * y1 == y_target
      puts "a: #{a} | b: #{b} | Step a: -#{y1 / y0.gcd(y1)} | Step b: #{y0 / y0.gcd(y1)} | FPB: #{y0.gcd(y1)} | Equation: #{y0}a + #{y1}b = #{y_target}".colorize(:light_magenta)
      if can_equal_to_target
        lowest_possible_y = { a:, b: }
        # break
      end
      y_possibilities << { a: a, b: b } if can_equal_to_target
    end

    puts "Lowest Possible X: #{lowest_possible_x}".colorize(:light_magenta)
    puts "Lowest Possible Y: #{lowest_possible_y}".colorize(:light_magenta)
    puts
    puts "X Possibilities: #{x_possibilities}".colorize(:light_magenta)
    puts "Y Possibilities: #{y_possibilities}".colorize(:light_magenta)
    possibilities = x_possibilities & y_possibilities
    puts "Common Possibilities: #{possibilities}".colorize(:light_magenta)
    puts

    # p possibilities
    # puts
    possibilities.min_by { |possibility| possibility[:a] * 3 + possibility[:b] }
  end.compact

  counter = possibles.sum do |possible|
    puts "A: #{possible[:a]}, B: #{possible[:b]}".colorize(:light_magenta)
    inner_counter = (possible[:a] * 3) + possible[:b]
    puts "A-> #{possible[:a] * 3}, B-> #{possible[:b]} => #{inner_counter}".colorize(:light_magenta)
    puts
    inner_counter
  end

  puts "Answer: #{counter}".colorize(:light_red)
end

puts
puts time

# P1: 31581 -> Too low
