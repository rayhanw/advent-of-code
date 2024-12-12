require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
X_MAX = FILE[0].size
Y_MAX = FILE.size
unique_keys = FILE.flatten.flat_map(&:chars).uniq
colors = unique_keys.map.with_index do |k, i|
  [k, String.colors[i + 3]]
end.to_h

def flood_fill(visited, result, coordinates, char, group_id)
  stack = [coordinates]
  while stack.any?
    stack.pop => [current_x, current_y]
    next if visited[current_y][current_x]

    visited[current_y][current_x] = true
    result[current_y][current_x] = group_id

    # Explore the cardinal directions
    up = [current_x, current_y - 1]
    down = [current_x, current_y + 1]
    left = [current_x - 1, current_y]
    right = [current_x + 1, current_y]

    [up, down, left, right].each do |(neighbor_x, neighbor_y)|
      if (neighbor_x >= 0 && neighbor_x < X_MAX) && (neighbor_y >= 0 && neighbor_y < Y_MAX) && !visited[neighbor_y][neighbor_x] && FILE[neighbor_y][neighbor_x] == char
        stack << [neighbor_x, neighbor_y]
      end
    end
  end

  result
end

def difference(array)
  array.each_cons(2).count { |pair| (pair[1] - pair[0]) > 1 }
end

map = Hash.new { |h, k| h[k] = [] }
time = Benchmark.measure do
  group_id = 1
  visited = Array.new(Y_MAX) { Array.new(X_MAX, false) }
  result = Array.new(Y_MAX) { Array.new(X_MAX, nil) }

  FILE.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      map[char] << [x, y]
      print char.colorize(colors[char]) + " "
    end
    puts
  end

  puts

  FILE.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      unless visited[y][x]
        flood_fill(visited, result, [x, y], char, group_id)
        group_id += 1
      end
    end
  end
  group_map = Hash.new { |h, k| h[k] = { coordinates: [], area: 0, perimeter: 0, perimeter_coordinates: [] } }
  result.each_with_index do |row, y|
    puts row.join(" ")
    row.each_with_index do |char, x|
      group_map[char][:coordinates] << [x, y]
      group_map[char][:area] += 1
    end
  end

  big_counter = 0

  group_map.each do |group_map_id, value|
    coordinates = value[:coordinates]
    coordinates.each do |coordinate|
      up = [coordinate[0], coordinate[1] - 1]
      down = [coordinate[0], coordinate[1] + 1]
      left = [coordinate[0] - 1, coordinate[1]]
      right = [coordinate[0] + 1, coordinate[1]]

      up_rule = up[1].negative? || result[up[1]][up[0]] != group_map_id
      down_rule = down[1] >= Y_MAX || result[down[1]][down[0]] != group_map_id
      left_rule = left[0].negative? || result[left[1]][left[0]] != group_map_id
      right_rule = right[0] >= X_MAX || result[right[1]][right[0]] != group_map_id

      value[:perimeter_coordinates] << { coordinates: up, direction: :up } if up_rule
      value[:perimeter_coordinates] << { coordinates: down, direction: :down } if down_rule
      value[:perimeter_coordinates] << { coordinates: left, direction: :left } if left_rule
      value[:perimeter_coordinates] << { coordinates: right, direction: :right } if right_rule
      value[:perimeter] += [up_rule, down_rule, left_rule, right_rule].count(true)
    end

    counter = 0
    value[:perimeter_coordinates].group_by { |h| h[:direction] }.each do |direction, value|
      coordinates = value.map { |h| h[:coordinates] }
      # puts "Direction: #{direction}"
      # puts "Coordinates: #{coordinates}"
      if %i[left right].include?(direction)
        x_grouped = coordinates.group_by(&:first)
        x_grouped.each_value do |coordinates|
          y_coordinates = coordinates.map(&:last)
          counter += difference(y_coordinates) + 1
        end
      else
        y_grouped = coordinates.group_by(&:last)
        y_grouped.each_value do |coordinates|
          y_coordinates = coordinates.map(&:first)
          counter += difference(y_coordinates) + 1
        end
      end
    end
    big_counter += (value[:area] * counter)
    puts "Group #{group_map_id} | Counter: #{counter} | Area: #{value[:area]} | Total: #{value[:area] * counter}"
  end

  puts "Big Counter: #{big_counter}".colorize(:green)
  # answer = group_map.values.sum do |h|
  #   h[:area] * h[:perimeter]
  # end

  # puts "Answer: #{answer}".colorize(:green)
end

puts
puts time
