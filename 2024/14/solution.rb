require 'benchmark'
require 'chunky_png'
require 'colorize'
require 'colorized_string'

FILE = File.readlines('input.txt').map(&:strip)
X_MAX = 101
Y_MAX = 103
X_MID = X_MAX / 2
Y_MID = Y_MAX / 2
MAX_SECONDS = 10_000
ALPHABET = ('A'..'Z').to_a

def determine_quadrant(coordinates)
  x, y = coordinates
  if x < X_MID && y < Y_MID
    'tl'
  elsif x > X_MID && y < Y_MID
    'tr'
  elsif x < X_MID && y > Y_MID
    'bl'
  elsif x > X_MID && y > Y_MID
    'br'
  end
end

def parse_input
  robots = []
  FILE.each_with_index do |line, idx|
    position, velocities = line.split
    pos_x, pos_y = position.gsub('p=', '').split(',').map(&:to_i)
    vel_x, vel_y = velocities.gsub('v=', '').split(',').map(&:to_i)

    robots << { position: [pos_x, pos_y], velocity: [vel_x, vel_y] }
  end

  robots
end

def move_robot(map, robot, second_counter)
  x_pos, y_pos = robot[:position]
  x_vel, y_vel = robot[:velocity]
  # x_move = x_vel % X_MAX
  # y_move = y_vel % Y_MAX
  x_pos_end = (x_pos + x_vel) % X_MAX
  y_pos_end = (y_pos + y_vel) % Y_MAX

  map[y_pos_end][x_pos_end] = if map[y_pos_end][x_pos_end] == '.'
                                1
                              elsif map[y_pos_end][x_pos_end].is_a?(Integer)
                                map[y_pos_end][x_pos_end] + 1
                              end

  robot[:position] = [x_pos_end, y_pos_end] # For P2
end

time = Benchmark.measure do
  tile = Array.new(Y_MAX) { Array.new(X_MAX) { '.' } }
  # Print and parse input
  robots = parse_input
  # Place robots on map
  second_counter = 1
  until second_counter > MAX_SECONDS
    robots.each do |robot|
      tile[robot[:position][1]][robot[:position][0]] = '.'
    end

    robots.each do |robot|
      move_robot(tile, robot, second_counter)
    end

    if second_counter > 2000
      png = ChunkyPNG::Image.new(X_MAX, Y_MAX, ChunkyPNG::Color::TRANSPARENT)
      tile.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          png[x, y] = cell.is_a?(Integer) ? ChunkyPNG::Color.rgb(0, 255, 0) : ChunkyPNG::Color::BLACK
        end
      end
      png.save("frames/frame_#{second_counter}.png")
    end

    second_counter += 1
  end

  counters = {
    tl: 0,
    tr: 0,
    bl: 0,
    br: 0
  }
  tile.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next unless char.is_a?(Integer)

      position_label = determine_quadrant([x, y])
      counters[position_label.to_sym] += char if position_label
    end
  end

  pp counters

  puts "Answer: #{counters.values.reduce(:*)}".colorize(:green)
end

puts
puts time

# P2: 230436441 -> too high
# P2: 1000 -> too low
# P2: 1122 -> too low
