file = File.readlines("day_13.txt").map(&:strip)
coordinates = []
instructions = []

file.each do |line|
	if line.match?(/\d+\,\d+/)
		coord = line.split(",")
		coordinates << [coord[0].to_i, coord[1].to_i]
	else
		if !line.empty?
			instructions << line.match(/(x|y)=\d+/)[0]
		end
	end
end

max_x = coordinates.map { |coord| coord[0] }.max
max_y = coordinates.map { |coord| coord[1] }.max
instructions.map! { |i| i.split("=") }.map! { |i| [i[0], i[1].to_i] }

dots = Array.new(max_y + 1) { Array.new(max_x + 1, ' ') }

coordinates.each do |coord|
	x = coord[0]
	y = coord[1]
	dots[y][x] = '█'
end

instructions.each do |ins|
	if ins[0] == "y"
		y_plane = ins[1]
		dots = dots.group_by.with_index { |_, i| i < y_plane }
		dots[false].delete_at(0)
		diff = dots[true].length - dots[false].length
		second_group = dots[false]
		diff.times do
			second_group << Array.new(second_group[0].length, ' ')
		end
		
		second_group.reverse.each_with_index do |row, i|
			row.each_with_index do |num, j|
				if num == '█'
					dots[true][i][j] = '█'
				end
			end
		end

		dots = dots[true]
	elsif ins[0] == "x"
		x_plane = ins[1]
		left_group = []
		right_group = []
		dots.each do |row|
			left_group << row[0..(x_plane - 1)]
			right_group << row[(x_plane + 1)..-1]
		end

		diff = left_group[0].length - right_group[0].length
		diff.times do
			right_group.each do |row|
				row << '█' * diff
			end
		end

		right_group.map! { |col| col.reverse! }


		left_group.each_with_index do |row, i|
			row.each_with_index do |num, j|
				r_g_content = right_group[i][j]
				if r_g_content == '█'
					left_group[i][j] = '█'
				end
			end
		end

		dots = left_group
	end

	if dots.instance_of?(Hash)
		dots = dots[true]
	end
end

dots.each do |dot|
	p dot.join(" ")
end

File.open("day_13_result.txt", "w") do |f|
	dots.each do |arr|
		f.write("#{arr.join(" ")}\n")
	end
end
