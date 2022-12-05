file = File.readlines("day_2.txt").map(&:strip)

# depth = 0
# position = 0

# PART 1
# file.each do |line|
# 	ins = line.split(" ")

# 	if ins[0] == "forward"
# 		position += ins[1].to_i
# 	elsif ins[0] == "down"
# 		depth += ins[1].to_i
# 	elsif ins[0] == "up"
# 		depth -= ins[1].to_i
# 	end
# end

# p depth * position

# PART 2
depth = 0
aim = 0
hor_position = 0

file.each do |line|
	ins = line.split

	if ins[0] == "forward"
		hor_position += ins[1].to_i
		increase = ins[1].to_i * aim
		depth += increase
	elsif ins[0] == "down"
		aim += ins[1].to_i
	elsif ins[0] == "up"
		aim -= ins[1].to_i
	end
end

# p hor_position
# p depth

p hor_position * depth
