file = File.readlines("day_4.txt")

input = file[0].strip.split(",")
boards = file[2..-1].map(&:strip).map { |a| a.split(",") }.reject(&:empty?).map { |group| group[0].split }.each_slice(5).to_a

def check_win?(board)
	# CHECK HORIZONTAL
	return true if board.any? { |row| row.all? { |x| x == "x" } }

	board.each_with_index do |_, index|
		return true if board.all? { |row| row[index] == "x" }
	end

	return false
end

input.each do |num|
	boards.each do |board|
		board.each do |row|
			row.each_with_index do |number, index|
				if number == num
					row[index] = "x"
 				end
			end

			# CHECK WIN
			# win = check_win?(board)

			# if win
			# 	p board.flatten.reject { |x| x == "x" }.map(&:to_i).sum * num.to_i
			# 	exit
			# end
		end

		# CHECK LAST WIN
		losing_boards = boards.reject { |b| check_win?(b) }
		if losing_boards.length == 1
			losing_board = losing_boards.first
			losing_board.each_with_index do |b, idx|
				b.each_with_index do |b_num, b_idx|
					if num == b_num
						losing_board[idx][b_idx] = "x"
					end
				end
			end

			if check_win?(losing_board)
				p losing_board.flatten.reject { |x| x == "x" }.map(&:to_i).sum * num.to_i
			end
		end
	end
end

