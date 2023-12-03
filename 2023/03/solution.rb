# frozen_string_literal: true

require 'colorized_string'
require_relative 'helpers'

file = File.readlines('input.txt').map(&:strip)
numbers = {}
neighbors = []

file.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    next unless char.match?(/\d+/)

    position = [x, y]
    # Get surroundings
    numbers[position] = {
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

numbers.each do |pos, info|
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
  has_symbol_neighbor = values.any? { |v| v != '.' && v&.match?(/\W+/) }

  next unless has_symbol_neighbor

  puts ColorizedString["#{pos}: #{char}"].colorize(:yellow)
  left_right = left_right_neighbors(file, pos[1], pos[0])
  neighbors << left_right
  p left_right
  puts
end

neighbor_groups = {}
neighbors.each do |h|
  if neighbor_groups.key?(h[:y])
    neighbor_groups[h[:y]] << h[:result]
  else
    neighbor_groups[h[:y]] = [h[:result]]
  end
end

answer = []
neighbor_groups.each do |k, v|
  answer << v.uniq
end

p "ANSWER: #{answer.flatten.sum}"
