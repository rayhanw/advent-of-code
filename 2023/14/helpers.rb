NOTATION_SCORING = {
  'O' => 1,
  '.' => 2,
  '#' => 999
}.freeze

def bubble_sort(array)
  size = array.size
  return array if size <= 1

  loop do
    swapped = false

    (size - 1).times do |i|
      if NOTATION_SCORING[array[i]] > NOTATION_SCORING[array[i + 1]] && array[i] != '#' && array[i + 1] != '#'
        array[i], array[i + 1] = array[i + 1], array[i]
        swapped = true
      end
    end

    break unless swapped
  end

  array
end
