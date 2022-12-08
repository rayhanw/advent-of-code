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

puts "counts:"
p counts.flatten.sort.reverse

puts

puts "count:"
p counts.flatten.sort.reverse[0]
