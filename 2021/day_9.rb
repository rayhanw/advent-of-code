FILE = File.readlines("day_9.txt").map(&:strip)

FILE.map! do |line|
  line.to_s.chars.map(&:to_i)
end

def part_1
  i = 0
  numbers = []

  while i < FILE.size
    row = FILE[i]

    row.each_with_index do |num, j|
      lowers = []
      prev_num = j == 0 ? nil : row[j - 1]
      next_num = j == (row.length - 1) ? nil : row[j + 1]
      prev_row = i == 0 ? nil : FILE[i - 1]
      next_row = i == (FILE.size - 1) ? nil : FILE[i + 1]
      up_num = prev_row ? prev_row[j] : nil
      down_num = next_row ? next_row[j] : nil
      lowers << (prev_num && prev_num > num)
      lowers << (next_num && next_num > num)
      lowers << (up_num && up_num > num)
      lowers << (down_num && down_num > num)
      numbers << num if lowers.compact.all? { |bool| bool }
    end

    puts '--- ROW FINISH ---'

    i += 1
  end

  p numbers.map { |num| num + 1 }.sum
end

def consecutive?(numbers)
  numbers.each_cons(2).all? { |x, y| (x + 1) == y }
end

def check_numbers(row:, j:, i:, num:)
  prev_num = j == 0 ? nil : row[j - 1]
  next_num = j == (row.length - 1) ? nil : row[j + 1]
  prev_row = i == 0 ? nil : FILE[i - 1]
  next_row = i == (FILE.size - 1) ? nil : FILE[i + 1]
  up_num = prev_row ? prev_row[j] : nil
  down_num = next_row ? next_row[j] : nil

  {
    prev_num: prev_num && prev_num > num,
    next_num: next_num && next_num > num,
    up_num: up_num && up_num > num,
    down_num: down_num && down_num > num
  }
end

def fill_coordinate(row, i)
  coordinate = []
  row.each_with_index do |num, j|
    lowers = []
    sides = check_numbers(row: row, j: j, i: i, num: num)

    lowers << sides[:prev_num]
    lowers << sides[:next_num]
    lowers << sides[:up_num]
    lowers << sides[:down_num]
    coordinate << [i, j] if lowers.compact.all? { |bool| bool }
  end

  coordinate
end

def get_coordinates(array)
  i = 0
  coordinates = []
  while i < array.size
    row = array[i]
    coordinate = fill_coordinate(row, i)
    coordinates << coordinate unless coordinate.empty?

    i += 1
  end

  coordinates
end

def adjacent_coords(coordinates)
  max_x = FILE[0].length
  max_y = FILE.length
  adjacent_coords = coordinates.map do |coord|
    x = coord[0]
    y = coord[1]

    next if x.nil? || y.nil?

    num = FILE[x][y]

    prev_num = FILE[x][y - 1]
    next_num = FILE[x][y + 1]
    up_num = x.zero? ? nil : FILE[x - 1][y]
    down_num = x == (max_y - 1) ? nil : FILE[x + 1][y]
    places = [
      { num: prev_num, x: x, y: (y.zero? ? nil : y - 1)},
      { num: next_num, x: x, y: (y + 1) == max_x ? nil : y + 1 },
      { num: up_num, x: (x.zero? ? nil : x - 1), y: y },
      { num: down_num, x: (x == (max_y - 1) ? nil : x + 1), y: y }
    ]

    places.filter { |h| h[:num] && (h[:num] - 1) == num && h[:num] != 9 }
  end

  adjacent_coords.flatten(1).compact.each { |coord| coord.delete(:num) }.map { |coord| [coord[:x], coord[:y]] }
end

def part_2
  coordinates = get_coordinates(FILE)
  # coordinates = [
  #   [[0, 1]],
  #   [[0, 9]],
  #   [[2, 2]],
  #   [[4, 6]]
  # ]
  coordinates = coordinates.flatten(1).map { |ary| [ary] }
  basins = []
  used_coordinates = coordinates.dup.flatten(1)
  coordinates.each do |coord|
    size = 1
    loop do
      coord = adjacent_coords(coord).uniq
      used_coordinates << coord
      # pp used_coordinates.flatten(1)
      used_coordinates.reject!(&:empty?)

      break if coord.empty?

      size += coord.uniq.length
    end

    basins << size
  end

  # p basins.sort.reverse.first(3).reduce(:*)
end

part_2
