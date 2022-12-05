file = File.readlines("day_1.txt").map(&:strip).map(&:to_i)

increase = 0
index = 0

# PART 1
# readings = file.length

# while readings.positive?

# 	current_reading = file[index]
# 	next_reading = file[index + 1]

# 	if current_reading && next_reading && current_reading < next_reading
# 		increase += 1
# 	end

# 	index += 1
# 	readings -= 1
# end

# p increase

# PART 2
# while readings.positive?

# 	index += 1
# 	readings -= 1
# end
groups = file.map.with_index do |number, index|
	group = [number, file[index + 1], file[index + 2]]

	group
end

sum_group = groups.map { |group| group.compact.sum }
readings = sum_group.length

while readings.positive?
	current_group = sum_group[index]
	next_group = sum_group[index + 1]

	if current_group && next_group && current_group < next_group
		increase += 1
	end

	index += 1
	readings -= 1
end

p increase
