file = File.readlines("input.txt").map(&:strip).map do |line|
  n = line.to_i

  if n != 0
    n
  else
    line
  end
end

ary = file.join("|").split("||")
sorted = ary.map do |grp|
  grp.split("|").map(&:to_i).sum
end.sort_by { |num| -num }

p "P1: #{sorted[0]}"

top_three = sorted[0..2]
p "P2: #{top_three.sum}"

###
# Elves require Calories to travel
# One important consideration is food - in particular, the number of Calories each Elf is carrying (your puzzle input).
# The Elves take turns writing down the number of Calories contained by the various meals, snacks, rations, etc.
# that they've brought with them, one item per line.
#
# Each Elf separates their own inventory from the previous Elf's inventory (if any) by a blank line.
###
