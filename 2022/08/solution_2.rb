require 'colorize'

file = File.readlines("input.txt").map(&:strip)
map = file.map(&:chars).map { |sub| sub.map(&:to_i) }
max_row = map.length
max_col = map[0].length
counts = []

puts "Map:"
map.each do |sub|
  p sub
end
puts

map.each_with_index do |sub_map, y|
  sub_map.each_with_index do |height, x|
    up_neighbors = map.map { |sub_e| sub_e[x] }.first(y).reverse
    right_neighbors = sub_map[(x + 1)..-1]
    down_neighbors = map.map { |sub_e| sub_e[x] }.last(max_row - y - 1)
    left_neighbors = sub_map[0...x].reverse

    puts "height: #{height}".colorize(:cyan)
    p "up: #{up_neighbors}"
    p "right: #{right_neighbors}"
    p "down: #{down_neighbors}"
    p "left: #{left_neighbors}"

    puts "checks:"

    # up check
    up_index = up_neighbors.find_index { |num| num >= height }
    up_blocked = up_index.nil?
    up_visibility = up_blocked ? up_neighbors.count : up_neighbors[0..up_index].count
    puts "\s-> up VIS: #{up_visibility}".colorize(:red)
    # up_visibility = up_index ? up_neighbors[0..up_index].count : 0
    # p "up idx: #{up_index}"
    # p "up vis neighbors: #{up_neighbors[0..up_index]}"
    # puts "\s-> up VIS: #{up_visibility}"

    #left check
    left_index = left_neighbors.find_index { |num| num >= height }
    left_blocked = left_index.nil?
    left_visibility = left_blocked ? left_neighbors.count : left_neighbors[0..left_index].count
    puts "\s-> left VIS: #{left_visibility}".colorize(:blue)

    # right check
    right_index = right_neighbors.find_index { |num| num >= height }
    right_blocked = right_index.nil?
    right_visibility = right_blocked ? right_neighbors.count : right_neighbors[0..right_index].count
    puts "\s-> right VIS: #{right_visibility}".colorize(:yellow)

    # down check
    down_index = down_neighbors.find_index { |num| num >= height }
    down_blocked = down_index.nil?
    down_visibility = down_blocked ? down_neighbors.count : down_neighbors[0..down_index].count
    puts "\s-> down VIS: #{down_visibility}".colorize(:magenta)

    puts

    total_visibility = up_visibility * left_visibility * right_visibility * down_visibility
    puts "total visibility: #{total_visibility}".colorize(:blue).underline

    counts << total_visibility

    puts
  end
end

# map[1..-2].each_with_index do |sub, y|
#   sub[1..-2].each_with_index do |ele, x|
#     up = map.map { |sub_e| sub_e[x + 1] }.first(y + 2)
#     right = sub[(x + 1)..-1].reverse
#     down = map.map { |sub_e| sub_e[x + 1] }.last(max_row - 1 - y).reverse
#     left = sub[0..(x + 1)]
#     p "ele: #{ele}"
#     res = []

#     # up check
#     up_covers = up[0..-2].reverse
#     t_index = up_covers.find_index { |num| up.last <= num }
#     up_count = t_index ? up_covers[0..t_index].count : 1
#     p up_covers
#     p "up: #{up_covers[0..t_index]}"
#     # p "up_count: #{up_count}"


#     # Left check
#     left_covers = left[0..-2].reverse
#     l_index = left_covers.find_index { |num| left.last <= num }
#     left_count = left_covers[0..l_index].count
#     p left_covers
#     p "left: #{left_covers[0..l_index]}"
#     # p "left_count: #{left_count}"

#     # down check
#     down_covers = down[0..-2].reverse
#     d_index = down_covers.find_index { |num| down.last <= num }
#     down_count = down_covers[0..d_index].count
#     p down_covers
#     p "down: #{down_covers[0..d_index]}"
#     # p "down_count: #{down_count}"

#     # Right check
#     right_covers = right[0..-2].reverse
#     r_index = right_covers.find_index { |num| right.last <= num }
#     right_count = right_covers[0..r_index].count
#     p right_covers
#     p "right: #{right_covers[0..r_index]}"
#     # p "right_count: #{right_count}"

#     total_visibility = left_count * up_count * right_count * down_count
#     res << total_visibility

#     puts
#     counts.unshift res
#   end
# end

puts "counts:"
p counts.flatten.sort.reverse

puts

puts "count:"
p counts.flatten.sort.reverse[0]
