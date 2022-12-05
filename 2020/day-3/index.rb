require_relative "trees"


def trees_traversed(slope_x, slope_y)
  max_movement = TREES.length
  max_char_per_line = TREES[0].length
  answer = 0
  current_x_position = 0
  current_y_position = 0

  while max_movement.positive?
    current_x_position += slope_x
    current_y_position += slope_y
    y_pos = TREES[current_y_position]

    if y_pos
      answer += 1 if y_pos[current_x_position % max_char_per_line] == '#'
    end

    max_movement -= 1
  end

  answer
end

tree_1_1 = trees_traversed(1, 1)
tree_3_1 = trees_traversed(3, 1)
tree_5_1 = trees_traversed(5, 1)
tree_7_1 = trees_traversed(7, 1)
tree_1_2 = trees_traversed(1, 2)

p tree_1_1
p tree_3_1
p tree_5_1
p tree_7_1
p tree_1_2
p [tree_1_1, tree_3_1, tree_5_1, tree_7_1, tree_1_2].inject(:*)

# class TreeGrid
#   def self.from(file)
#     rows = File.readlines(file)
#     TreeGrid.new(rows)
#   end

#   def initialize(rows)
#     self.rows = rows
#     self.width = rows.first.scan(/[\.\#]/).length
#   end

#   def at(y, x)
#     self.rows[y][x % width]
#   end

#   def tree?(y, x)
#     at(y, x) == '#'
#   end

#   def each(&block)
#     (0...self.rows.length).each(&block)
#   end

#   def height
#     rows.length
#   end

#   private

#   attr_accessor :width, :rows
# end

# grid = TreeGrid.from('trees.txt')

# def count_trees(grid, slope_x, slope_y)
#   trees = 0
#   x = 0
#   y = 0

#   while y < grid.height
#     trees += 1 if grid.tree?(y, x)
#     y += slope_y
#     x += slope_x
#   end

#   trees
# end

# puts count_trees(grid, 3, 1)
