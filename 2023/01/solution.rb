require 'colorized_string'

file = File.readlines("input.txt").map(&:strip).reject(&:empty?)
count = 0

p file

file.each do |line|
  numbers = line.gsub(/\D+/, '').split("")
  if numbers.length == 1
    numbers[1] = numbers[0]
  end
  num = "#{numbers[0]}#{numbers[-1]}".to_i
  count += num
end

puts
p count
