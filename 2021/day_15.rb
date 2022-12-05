file = File.readlines("day_15.txt").map(&:strip).map { |line| line.chars.map(&:to_i) }
initial_x_size = file[0].length
initial_y_size = file[0].size

def min_path_sum(grid)
  rows = grid.length - 1
  cols = grid[0].length - 1

  # First row
  (1..cols).each do |i|
    grid[0][i] += grid[0][i - 1]
  end

  # First col
  (1..rows).each do |i|
    grid[i][0] += grid[i - 1][0]
  end

  # Inner cells
  (1..rows).each do |i|
    (1..cols).each do |j|
      grid[i][j] += [grid[i - 1][j], grid[i][j - 1]].min
    end
  end

  grid[-1][-1]
end

# GROW RIGHT
file.each do |line|
  line_one = line.map { |num| num == 9 ? 1 : (num + 1) }
  line_two = line_one.map { |num| num == 9 ? 1 : (num + 1) }
  line_three = line_two.map { |num| num == 9 ? 1 : (num + 1) }
  line_four = line_three.map { |num| num == 9 ? 1 : (num + 1) }
  line << [line_one, line_two, line_three, line_four]
  line.flatten!
end

# GROW DOWN
file.first(10).map { |line| line.map { |num| num == 9 ? 1 : (num + 1) } }.each do |line|
  file << line
end

file[10..20].map { |line| line.map { |num| num == 9 ? 1 : (num + 1) } }.each do |line|
  file << line
end

file[20..30].map { |line| line.map { |num| num == 9 ? 1 : (num + 1) } }.each do |line|
  file << line
end

file[30..40].map { |line| line.map { |num| num == 9 ? 1 : (num + 1) } }.each do |line|
  file << line
end

file.each do |row|
  p row.join(" ")
end

p min_path_sum(file)
