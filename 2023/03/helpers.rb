def left_right_neighbors(grid, x, y)
  # Left direction
  left = []
  (1..x).each do |i|
    coords = [y, x - i]
    break if grid[coords[0]][coords[1]].match?(/\W+/)

    left << grid[coords[0]][coords[1]]
  end
  left.reverse!

  # Right direction
  right = []
  ((x - 1)...grid[y].length).each do |i|
    coords = [y, i + 1]
    break if grid[coords[0]][coords[1]]&.match?(/\W+/)

    right << grid[coords[0]][coords[1]]
  end

  {result: (left + right).join("").to_i, y:, x:}
end
