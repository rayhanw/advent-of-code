require 'colorized_string'

file = File.readlines("input.txt").map(&:strip)
count = 0
mapping = {
  1 => "one",
  2 => "two",
  3 => "three",
  4 => "four",
  5 => "five",
  6 => "six",
  7 => "seven",
  8 => "eight",
  9 => "nine",
  0 => "zero"
}
char_mapping = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
  "zero" => 0
}

file.each do |line|
  line_groups = []
  mapping.each do |k, v|
    line = line.gsub(k.to_s, v)
  end
  p "LINE: #{line}"
  chars = line.split('')
  chars.each_with_index do |char, i|
    char_groups = "#{char}#{chars[(i + 1)..(i + 4)].join('')}"
    char_mapping.each do |k, v|
      if char_groups.include?(k)
        line_groups << v
      end
    end
  end
  first = line_groups[0]
  last = line_groups[-1]
  num = "#{first}#{last}".to_i
  count += num
  puts
end

p "ANSWER: #{count}"
