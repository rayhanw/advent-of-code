file = File.readlines("input.txt").map(&:strip)
map = file.map(&:chars).map { |sub| sub.map(&:to_i) }
max_row = map.length
max_col = map[0].length
count = 0

# puts "full map:"
# map.each do |sub|
#   print "["
#   sub.each do |ele|
#     print ele
#   end
#   print "]\n"
# end

# puts

# puts "middle map:"
# map[1..-2].each_with_index do |sub, y|
#   print "["
#   sub[1..-2].each_with_index do |ele, x|
#    print ele
#   end
#   print "]\n"
# end

# puts

map[1..-2].each_with_index do |sub, y|
  sub[1..-2].each_with_index do |ele, x|
    top = map.map { |sub_e| sub_e[x + 1] }.first(y + 2)
    right = sub[(x + 1)..-1].reverse
    bottom = map.map { |sub_e| sub_e[x + 1] }.last(max_row - 1 - y).reverse
    left = sub[0..(x + 1)]
    # p "ele: #{ele} | left: #{left} | top: #{top} | right: #{right} | bottom: #{bottom}"

    # if numbers from start up until the second last one is bigger or equals to the last one -> false
    res = []

    # Left check
    left_covers = left[0..-2]
    left_covered = left_covers.all? { |num| num < left.last }
    # p "left covered: #{left_covered}"
    res << left_covered

    # Top check
    top_covers = top[0..-2]
    top_covered = top_covers.all? { |num| num < top.last }
    # p "top covered: #{top_covered}"
    res << top_covered

    # Right check
    right_covers = right[0..-2]
    right_covered = right_covers.all? { |num| num < right.last }
    # p "right covered: #{right_covered}"
    res << right_covered

    # Bottom check
    bottom_covers = bottom[0..-2]
    bottom_covered = bottom_covers.all? { |num| num < bottom.last }
    # p "bottom covered: #{bottom_covered}"
    res << bottom_covered

    # puts
    # p "res: #{res}"

    should_add = res.any? { |ele| ele }
    # p "should_add: #{should_add}"
    count += 1 if should_add

    # if ele > top || ele > right || ele > bottom || ele > left
    #   puts "add"
    #   count += 1
    # end
    # puts
  end
end

# puts
puts "max outsides:"
outside_total = max_col * 4 - 4
puts "col: #{max_col - 1} | row: #{max_row - 1} => max: #{outside_total}"

puts "count: #{count}\n"

total = count + outside_total
puts "total: #{total}"
