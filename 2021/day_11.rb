file = File.readlines("day_11.txt").map(&:strip).map(&:chars).map { |col| col.map(&:to_i) }
file.each_with_index do |col, i|
	col.each_with_index do |num, j|
		file[i][j] = { number: num, flashed: false }
	end
end
flashes = []
MAX_I = file.size
MAX_J = file[0].size

def increment!(num)
	num[:number] += 1
end

def increment_with_coord!(file, coord)
	file[coord[0]][coord[1]][:number] += 1 if file[coord[0]][coord[1]][:number] != 10

	if file[coord[0]][coord[1]][:number] > 9
		file[coord[0]][coord[1]][:number] = 0
		file[coord[0]][coord[1]][:flashed] = true
	end
end

def step!(file)
	file.each_with_index do |col, i|
		col.each_with_index do |num, j|
			increment!(num)

			num[:flashed] = true if num[:number] > 9
		end
	end
end

def reset_flash!(num)
	num[:flashed] = false
end

def flash!(file, flashes)
	flashes << "FLASH"
	file.each_with_index do |col, i|
		col.each_with_index do |num, j|
			if num[:flashed]
				p "FLASHED"
				pos = [i, j]
				# GRAB SURROUNDINGS
				left_pos = [i, j.zero? ? nil : j - 1]
				right_pos = [i, (j + 1) == MAX_J ? nil : j + 1]
				top_pos = [i.zero? ? nil : i - 1, j]
				bottom_pos = [(i + 1) == MAX_I ? nil : i + 1, j]
				left_top_pos = [i.zero? ? nil : i - 1, j.zero? ? nil : j - 1]
				right_top_pos = [(i + 1) == MAX_I ? nil : i + 1, (j + 1) == MAX_J ? nil : j + 1]
				bottom_left_pos = [(i + 1) == MAX_I ? nil : i + 1, j.zero? ? nil : j - 1]
				bottom_right_pos = [(i + 1) == MAX_I ? nil : i + 1, (j + 1) == MAX_J ? nil : j + 1]
				surroundings = [left_pos, right_pos, top_pos, bottom_pos, left_top_pos, right_top_pos, bottom_left_pos, bottom_right_pos].reject { |ele| ele.include? nil }
				# RESET FLASH
				reset_flash!(num)
				# INCREMENT EACH SURROUNDING
				surroundings.each { |coord| increment_with_coord!(file, coord) }
				# while file.flatten.map { |h| h[:flashed] }.include? true
				# 	flash!(file, flashes)
				# end
			end
		end
	end
end

# FIRST ROUND
step!(file)

# NEXT ROUND
1.times do
	step!(file)
	flash!(file, flashes)
end

file.each do |row|
	pp row.map { |ele| ele[:number] }.join(" ")
end

# p flashes.count
