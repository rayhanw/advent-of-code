require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)[0].split(" ").map(&:to_i)
counters = Hash.new { |h, k| h[k] = 0 }

### RULES:
# - If stone is 0, replace with 1
# - If stone is even number, replace with 2 stones:
#   - Left stone -> Left half of number
#   - Right stone -> Right half of number
# - Else, stone number * 2024
###

def split_number(number)
  num_digits = Math.log10(number).to_i + 1
  half_digits = num_digits / 2

  divisor = 10**half_digits
  low = number % divisor
  high = number / divisor

  [high, low]
end

def transform_number(number)
  if number.is_a?(Integer) && number.zero?
    [1]
  elsif (Math.log10(number).to_i + 1).even?
    split_number(number)
  else
    [number * 2024]
  end
end

time = Benchmark.measure do
  puts "Initial arrangement:".colorize(:cyan)
  pp FILE
  puts

  modified = [*FILE]
  blink_count = 1
  # until blink_count == 76
  #   puts "After #{blink_count} #{blink_count == 1 ? 'blink' : 'blinks'}:".colorize(:light_blue)
  #   modified = modified.flat_map do |number|
  #     if memo.key?(number)
  #       memo[number]
  #     else
  #       next_number = transform_number(number)
  #       memo[number] = next_number
  #     end
  #   end

  #   # puts modified.join(" ")

  #   blink_count += 1
  # end

  modified.each do |num|
    counters[num] += 1
  end

  temp_counter = { **counters }
  until blink_count == 76
    puts "After #{blink_count} #{blink_count == 1 ? 'blink' : 'blinks'}:".colorize(:light_blue)
    temp_temp_counter = Hash.new { |h, k| h[k] = 0 }
    puts temp_counter.keys.join(" ")
    temp_counter.each do |num, val|
      transformed_nums = transform_number(num)
      # p [num, transformed_nums] if blink_count == 5
      # p [num, transformed_nums] if blink_count == 6
      transformed_nums.each do |transformed_num|
        temp_temp_counter[transformed_num] += 1 * val
      end
      # p temp_temp_counter if blink_count == 6
      # puts if blink_count == 6
      # p temp_temp_counter if blink_count == 5
    end
    temp_counter = temp_temp_counter

    blink_count += 1
  end
  p temp_counter

  puts "Answer: #{temp_counter.values.sum}".colorize(:green)
end

puts
puts time
