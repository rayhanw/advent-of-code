file = File.readlines("day_5.txt")

coords = file.map(&:strip).map do |coord|
	coord.split(" -> ").map do |point|
		po = point.split(",")
		[po[0].to_i, po[1].to_i]
	end
end

plot = {}

coords.each do |coor|
	p1 = coor[0]
	p2 = coor[1]
	x1 = p1[0]
	x2 = p2[0]
	y1 = p1[1]
	y2 = p2[1]

	if x1 == x2
		# VERTICAL LINE
		y_diff = y2 - y1
		if y_diff.positive?
			(y1..y2).each do |y|
				key = "#{x1},#{y}"
				# p key
				if plot.key? key
					plot[key] += 1
				else
					plot[key] = 1
				end
			end
		else
			(y2..y1).each do |y|
				key = "#{x1},#{y}"
				# p key
				if plot.key? key
					plot[key] += 1
				else
					plot[key] = 1
				end
			end
		end
	elsif y1 == y2
		# HORIZONTAL LINE
		x_diff = x2 - x1
		if x_diff.positive?
			(x1..x2).each do |x|
				key = "#{x},#{y1}"
				# p key
				if plot.key? key
					plot[key] += 1
				else
					plot[key] = 1
				end
			end
		else
			(x2..x1).each do |x|
				key = "#{x},#{y1}"
				# p key
				if plot.key? key
					plot[key] += 1
				else
					plot[key] = 1
				end
			end
		end
	else
		key = "#{x1},#{y1}"
		if plot.key? key
			plot[key] += 1
		else
			plot[key] = 1
		end
		until x1 == x2 && y1 == y2
			if x1 > x2
				x1 -= 1
			elsif x1 < x2
				x1 += 1
			end

			if y1 > y2
				y1 -= 1
			elsif y1 < y2
				y1 += 1
			end

			key = "#{x1},#{y1}"
			if plot.key? key
				plot[key] += 1
			else
				plot[key] = 1
			end
		end
	end
end

# p plot
p plot.values.count { |num| num >= 2 }
