require 'colorized_string'
require_relative 'helpers'

file = File.readlines('input.txt').map(&:strip)
symbols = {}
answer = []

file.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    next unless char.match?(/\W+/) && char != '.'

    position = [x, y]
    # Get surroundings
    symbols[position] = {
      char:,
      tl: [x - 1, y - 1],
      t: [x - 1, y],
      tr: [x - 1, y + 1],
      l: [x, y - 1],
      r: [x, y + 1],
      bl: [x + 1, y - 1],
      b: [x + 1, y],
      br: [x + 1, y + 1]
    }
  end
end

symbols.each do |pos, info|
  char = info[:char]
  tl = info[:tl]
  t = info[:t]
  tr = info[:tr]
  l = info[:l]
  r = info[:r]
  bl = info[:bl]
  b = info[:b]
  br = info[:br]
  tl_value = file[tl[0]][tl[1]]
  tl_value = '.' if tl.include?(-1)
  t_value = file[t[0]][t[1]]
  t_value = '.' if t.include?(-1)
  tr_value = file[tr[0]][tr[1]]
  tr_value = '.' if tr.include?(-1)
  l_value = file[l[0]][l[1]]
  l_value = '.' if l.include?(-1)
  r_value = file[r[0]][r[1]]
  r_value = '.' if r.include?(-1)
  bl_value = bl.include?(file.length) ? '.' : file[bl[0]][bl[1]]
  bl_value = '.' if bl.include?(-1)
  b_value = b.include?(file.length) ? '.' : file[b[0]][b[1]]
  b_value = '.' if b.include?(-1)
  br_value = br.include?(file.length) ? '.' : file[br[0]][br[1]]
  br_value = '.' if br.include?(-1)
  values = [tl_value, t_value, tr_value, l_value, r_value, bl_value, b_value, br_value]
  has_number_neighbor = values.any? { |v| v&.match?(/\d+/) }

  next unless has_number_neighbor

  # Filter the symbols that has 2 correct neighbors
  first_rule = values.count { |v| v.match?(/\d+/) } >= 2
  second_rule = l_value.match?(/\d+/) && r_value.match?(/\d+/)
  third_rule = [tl_value, t_value, tr_value].count { |v| v.match?(/\d+/) } >= 1 && [bl_value, b_value, br_value].count { |v| v.match?(/\d+/) } >= 1
  fourth_rule = (tl_value.match?(/\d+/) && tr_value.match?(/\d+/) && t_value.match?(/\D+/)) || (bl_value.match?(/\d+/) && br_value.match?(/\d+/) && b_value.match?(/\D+/))
  fifth_rule = (tl_value.match?(/\d+/) && r_value.match?(/\d+/)) || (tr_value.match?(/\d+/) && l_value.match?(/\d+/)) || (bl_value.match?(/\d+/) && r_value.match?(/\d+/)) || (br_value.match?(/\d+/) && l_value.match?(/\d+/))
  sixth_rule = (tl_value.match?(/\d+/) && l_value.match?(/\d+/)) || (tr_value.match?(/\d+/) && r_value.match?(/\d+/)) || (bl_value.match?(/\d+/) && l_value.match?(/\d+/)) || (br_value.match?(/\d+/) && r_value.match?(/\d+/))
  next unless first_rule && (second_rule || third_rule || fourth_rule || fifth_rule || sixth_rule)

  puts ColorizedString["#{pos}: #{char}"].colorize(:yellow)
  puts "TL: [#{tl[0]}, #{tl[1]}] -> #{tl_value}"
  puts "T : [#{t[0]}, #{t[1]}] -> #{t_value}"
  puts "TR: [#{tr[0]}, #{tr[1]}] -> #{tr_value}"
  puts "L : [#{l[0]}, #{l[1]}] -> #{l_value}"
  puts "R : [#{r[0]}, #{r[1]}] -> #{r_value}"
  puts "BL: [#{bl[0]}, #{bl[1]}] -> #{bl_value}"
  puts "B : [#{b[0]}, #{b[1]}] -> #{b_value}"
  puts "BR: [#{br[0]}, #{br[1]}] -> #{br_value}"
  puts

  positions = {}
  positions[:tl] = [tl[0], tl[1]] if tl_value.match?(/\d+/)
  positions[:t] = [t[0], t[1]] if t_value.match?(/\d+/)
  positions[:tr] = [tr[0], tr[1]] if tr_value.match?(/\d+/)
  positions[:l] = [l[0], l[1]] if l_value.match?(/\d+/)
  positions[:r] = [r[0], r[1]] if r_value.match?(/\d+/)
  positions[:bl] = [bl[0], bl[1]] if bl_value.match?(/\d+/)
  positions[:b] = [b[0], b[1]] if b_value.match?(/\d+/)
  positions[:br] = [br[0], br[1]] if br_value.match?(/\d+/)

  neighbors = {}
  positions.each do |dir, pos|
    neighbors[dir] = left_right_neighbors(file, pos[1], pos[0])
  end

  numbers = []
  neighbors.each do |_, info|
    numbers << info[:result]
  end

  neighbor_groups = {}
  neighbors.each do |_, v|
    if neighbor_groups.key?(v[:y])
      neighbor_groups[v[:y]] << v[:result]
    else
      neighbor_groups[v[:y]] = [v[:result]]
    end
  end

  neighbor_groups.each do |k, v|
    neighbor_groups[k] = v.uniq
  end

  answer << neighbor_groups.values.flatten.inject(:*)
end

puts "ANSWER: #{answer.sum}"
