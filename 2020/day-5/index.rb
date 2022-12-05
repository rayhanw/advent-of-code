require_relative "boarding_passes"

def seat_id(boarding_pass)
  min = 0
  max = 127
  range = (min..max).to_a
  last_min = 0
  last_max = 7
  last_range = (last_min..last_max).to_a

  row = 0
  column = 0

  first_7_chars = boarding_pass[0..6]
  last_3_chars = boarding_pass[7..9]

  first_7_chars.chars.each do |letter|
    middle = range[(range.length / 2) - 1]
    if letter == 'F'
      max = middle
      range = (min..max).to_a
    elsif letter == 'B'
      min = middle + 1
      range = (min..max).to_a
    end

    if range.length == 1
      row = range[0]
    end
  end

  last_3_chars.chars.each do |letter|
    middle = last_range[(last_range.length / 2)]
    if letter == 'R'
      last_min = middle
      last_range = (last_min..last_max).to_a
    elsif letter == 'L'
      last_max = middle - 1
      last_range = (last_min..last_max).to_a
    end

    if last_range.length == 1
      column = last_range[0]
    end
  end

  return row * 8 + column
end

seats = BOARDING_PASSES.map { |bp| seat_id(bp) }.sort
answer_1 = seats.max

p seats

seats.each_with_index do |seat, index|
  next_seat = seats[index + 1]
  if next_seat && next_seat - 1 != seat
    p seat
    p next_seat
  end
end
