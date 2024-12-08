require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
MEMO = {}
COLOR = {
  "G" => :white,
  "1" => :green,
  "2" => :blue,
  "3" => :yellow
}.freeze

def evaluate_expression(ops, numbers, total)
  result = numbers[0]
  ops.each_with_index do |op, i|
    case op
    when "*"
      result *= numbers[i + 1]
    when "+"
      result += numbers[i + 1]
    end
    return false if result > total
  end

  MEMO[key] = result
  result
end

def print_group(group_id)
  "G" + group_id.to_s.chars.map { |char| char.colorize(COLOR[char]) }.join(".")
end

def can_equal_to_total(numbers, total)
  success_signal = false

  dfs = lambda do |index, current_total, group_id|
    # Break recursion if we have already found a solution
    return true if success_signal

    # Another base case: If all numbers concatenated and evaluated to the total
    if numbers.join("").to_i == total
      success_signal = true
      # puts "Skipping computation: All numbers concatenated and evaluated to the total".colorize(:magenta)
      return true
    end

    # Base case: If we have processed all numbers
    if index == numbers.size
      answer = current_total == total
      # puts "[#{print_group(group_id)}] Reached end: CurrentTotal=#{current_total} | Total=#{total}. Evaluated to #{answer.to_s.colorize(answer ? :green : :red)}"
      success_signal = answer
      return answer
    end

    # Prune: If the current total exceeds the target
    if current_total > total
      # puts "[#{print_group(group_id)}] Pruning: CT=#{current_total} > Total=#{total}"
      return false
    end

    # puts "[#{print_group(group_id)}] Processing: CurrentTotal=#{current_total} | Total=#{total}"

    result = false
    # Case 1: Addition
    new_group_id = (group_id * 10) + 1 # + 1 for addition
    next_total = current_total + numbers[index]
    # puts "[#{print_group(group_id)}] Adding: #{current_total} + #{numbers[index]} => #{next_total} (#{print_group(new_group_id)})"
    result ||= dfs.call(index + 1, next_total, new_group_id)

    # Case 2: Multiplication
    new_group_id = (group_id * 10) + 2 # + 2 for multiplication
    next_total = current_total * numbers[index]
    # puts "[#{print_group(group_id)}] Multiplying: #{current_total} * #{numbers[index]} => #{next_total} (#{print_group(new_group_id)})"
    result ||= dfs.call(index + 1, next_total, new_group_id)

    # Case 3: Concatenation
    new_group_id = (group_id * 10) + 3 # + 3 for concatenation
    # Concatenate current_total with the next number
    next_total = (current_total.to_s + numbers[index].to_s).to_i
    # puts "[#{print_group(group_id)}] Concatenating: #{current_total} || #{numbers[index]} => #{next_total} (#{print_group(new_group_id)})"
    result ||= dfs.call(index + 1, next_total, new_group_id)

    result
  end

  # Start recursion from the first number
  dfs.call(1, numbers[0], 1)
end

COLOR.each do |char, color|
  print "#{char} => #{color.to_s.colorize(color)}\s|\s"
end
puts

time = Benchmark.measure do
  totals = 0
  FILE.each do |line|
    line.split(":") => [total, numbers]
    total = total.to_i
    numbers = numbers.split(" ").map(&:to_i)
    puts "Evaluating #{numbers} => #{total}".colorize(:yellow)
    if can_equal_to_total(numbers, total)
      # puts "Adding: #{total}".colorize(:yellow)
      totals += total
    else
      # puts "Skipping: #{total}".colorize(:red)
    end
  end

  puts "Total: #{totals}".colorize(:green)
end

puts time

# P1: 42_920_983_599_677 -> Too high
# P1: 1_985_268_524_462 🟢
# P2: 150_077_710_195_188 🟢
