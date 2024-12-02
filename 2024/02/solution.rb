require 'colorize'
require 'colorized_string'

file = File.readlines('input.txt').map(&:strip).reject(&:empty?)
grid = file.map { |line| line.split(" ").map(&:to_i) }

def all_ascend_or_desc_p1(line)
  diffs = []
  line.each_with_index do |num, idx|
    next_num = line[idx + 1]

    break if next_num.nil?

    diff = num - next_num
    diffs << diff
  end

  # Check if descending
  if diffs.all?(&:positive?)
    return diffs.all? { |diff| diff >= 1 && diff <= 3 } ? 1 : 0
  elsif diffs.all?(&:negative?)
    return diffs.all? { |diff| diff.abs >= 1 && diff.abs <= 3 } ? 1 : 0
  end

  0
end

def get_diffs(line)
  diffs = []
  line.each_with_index do |num, idx|
    next_num = line[idx + 1]

    break if next_num.nil?

    diff = num - next_num
    diffs << diff
  end
  diffs
end

def all_ascend_or_desc_p2(line)
  diffs = []
  line.each_with_index do |num, idx|
    next_num = line[idx + 1]

    break if next_num.nil?

    diff = num - next_num
    diffs << diff
  end

  # Check if descending
  if diffs.all?(&:positive?)
    return diffs.all? { |diff| diff >= 1 && diff <= 3 }
  elsif diffs.all?(&:negative?)
    return diffs.all? { |diff| diff.abs >= 1 && diff.abs <= 3 }
  end

  false
end

# def all_ascend_or_desc_p2(line, has_deleted: false)
#   diffs = get_diffs(line)

#   # Check if descending
#   if diffs.all?(&:positive?)
#     return diffs.all? { |diff| diff >= 1 && diff <= 3 } ? 1 : 0
#   elsif diffs.all?(&:negative?)
#     return diffs.all? { |diff| diff.abs >= 1 && diff.abs <= 3 } ? 1 : 0
#   else
#     if diffs.include?(0) && diffs.count(0) == 1 && !has_deleted
#       index_of_zero = diffs.index(0)
#       line.delete_at(index_of_zero)
#       return all_ascend_or_desc_p2(line, has_deleted: true)
#     end

#     positive_count = diffs.count(&:positive?)
#     negative_count = diffs.count(&:negative?)

#     if positive_count > negative_count && negative_count == 1 && !diffs.include?(0)
#       index_to_delete = diffs.index(&:negative?)
#     elsif negative_count > positive_count && positive_count == 1 && !diffs.include?(0)
#       index_to_delete = diffs.index(&:positive?)
#     else
#       return 0
#     end

#     if index_to_delete && !has_deleted
#       prev_line = [*line]
#       line.delete_at(index_to_delete + 1)
#       answer = all_ascend_or_desc_p2(line, has_deleted: true)
#       new_diffs = get_diffs(line)
#       if !answer.zero? && diffs.none? { |diff| diff < -3 || diff > 3 }
#         puts "Before: #{prev_line} => #{diffs}"
#         puts "Deleted: #{ColorizedString[line.to_s].colorize(:blue)} => #{new_diffs}"
#         puts "Answer: #{answer}\n\n"
#       end
#       return answer
#     end

#     return 0
#   end
# end

puts "--- PART 1 ---".colorize(:yellow)
puts grid.sum { |line| all_ascend_or_desc_p1(line) }
puts
puts "--- PART 2 ---".colorize(:yellow)
grid.each_with_index do |line, i|
  puts "#{line} on line #{i}"
end

counter = 0
grid.each_with_index do |line, i|
  original = all_ascend_or_desc_p2(line)
  if original
    counter += 1
    next
  end

  line.each_index do |idx|
    new_line = [*line]
    new_line.delete_at(idx)
    attempt = all_ascend_or_desc_p2(new_line)
    puts "Attempting on #{new_line} on line #{i} => #{attempt}"
    if attempt
      counter += 1
      break
    end
  end
end

puts "Answer: #{counter}"

# 323 => Too high
# 321 => Too high
# 266 => Too low
