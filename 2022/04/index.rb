file = File.readlines("input.txt").map(&:chomp).map { |l| l.split(",") }

contains = 0
file.each do |line|
  first = line[0].split("-").map(&:to_i)
  second = line[1].split("-").map(&:to_i)

  if first.first <= second.first && first.last >= second.last
    contains += 1
  elsif second.size >= first.size && second.first <= first.first && second.last >= first.last
    contains += 1
  else
    p first
    p second
    puts
  end
end

puts
print "RESULT: "
p contains
# sets.each do |set|
#   first = set[0]
#   second = set[1]

#   if first.first <= second.first && first.last >= second.last
#     puts "LOWER COVERED"
#   elsif second.size >= first.size && second.first <= first.first && second.last >= first.last
#     puts "HIGHER COVERED"
#   else
#     puts "UNCOVERED"
#   end
# end
