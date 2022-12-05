FILE = File.readlines("day_8.txt")
DIGITS = {
  0 => ["A", "B", "C", "" , "E", "F", "G"],
  1 => ["" , "" , "C", "" , "E", "" , "" ],
  2 => ["A", "" , "C", "D", "E", "" , "G"],
  3 => ["A", "" , "C", "D", "" , "F", "G"],
  4 => ["" , "B", "C", "D", "" , "F", "" ],
  5 => ["A", "B", "" , "D", "" , "F", "G"],
  6 => ["A", "B", "" , "D", "E", "F", "G"],
  7 => ["A", "" , "C", "" , "" , "F", "" ],
  8 => ["A", "B", "C", "D", "E", "F", "G"],
  9 => ["A", "B", "C", "D", "" , "F", "G"]
}
DIGITS_REV = DIGITS.map { |k, v| [v.reject(&:empty?).sort.join, k.to_s] }.to_h
PERMUTATIONS = "ABCDEFG".chars.permutation.to_a

def part_1
  groups = []

  FILE.each do |line|
    per_line = line.strip.split(" | ")
    input = per_line[0]
    output = per_line[1]

    group = {}

    output.split.each do |word|
      if group.key? word.length
        group[word.length][:initial] << word
      else
        group[word.length] = { initial: [word], input: [] }
      end
    end

    input.split.each do |word|
      if group.key? word.length
        group[word.length][:input] << word
      end
    end

    new_group = group.select do |k, v|
      v[:input].length == 1
    end

    new_group.each do |k, v|
      groups << v[:initial].length
    end
  end

  p groups.sum
end

# part_1

# 0 : top, topLeft, topRight, bottomLeft, bottomRight, bottom
# 1 : topRight, bottomRight
# 2 : top, topRight, mid, bottomLeft, bottom
# 3 : top, topRight, mid, bottomRight, bottom
# 4 : topLeft, topRight, mid, bottomRight
# 5 : top, topLeft, mid, bottomRight, bottom
# 6 : top, topLeft, mid, bottomLeft, bottomRight, bottom
# 7 : top, topRight, bottomRight
# 8 : top, topLeft, topRight, mid, bottomLeft, bottomRight, bottom
# 9 : top, topLeft, topRight, mid, bottomRight, bottom

# unique : 1,4,7,8
# same length: 2-3-5, 0-6-9

def part_2
  # groups = []

  FILE.each do |line|
    group = []
    per_line = line.strip.split(" | ")
    input = per_line[0]
    output = per_line[1]

    groups << group
  end


  # groups
  sum = 0
end

part_2
