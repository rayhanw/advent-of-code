file = File.readlines("input.txt").map(&:chomp).map { |l| l.split(",") }

contains = 0
file.each do |line|
  first = line[0].split("-").map(&:to_i)
  second = line[1].split("-").map(&:to_i)
  first_range = (first[0]..first[1]).to_a
  second_range = (second[0]..second[1]).to_a

  if (first_range & second_range).size.positive?
    contains += 1
  end
end

puts
print "RESULT: "
p contains
