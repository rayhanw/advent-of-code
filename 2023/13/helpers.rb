MULTIPLIER = 100

def summarize_answer(number_of_columns:, number_of_rows:)
  (number_of_rows * MULTIPLIER) + number_of_columns
end

def split_to_reflection(array, idx)
  [array.first(idx), array[idx..]]
end

def check_reflection(array, other)
  n = array.length
  checklist = []

  n.times do |i|
    first = array[i]
    second = other[i]
    is_equal = first == second
    checklist << is_equal
  end

  checklist.all? { |c| c == true }
end

def count_reflection(pattern)
  amount = 0
  (2..(pattern.size - 1)).to_a.each do |i|
    # puts ColorizedString["Splitting at #{i} and #{i + 1}"].colorize(:yellow)
    reflections = split_to_reflection(pattern, i)
    longer_array = reflections.max_by(&:length)
    longer_array_idx = reflections.index(longer_array)
    shorter_array = reflections.min_by(&:length)
    # n -> number of elements in the shorter array
    n = shorter_array.size
    # If left array is bigger, then take the last n element
    if longer_array_idx.zero?
      sublist = [longer_array.last(n), shorter_array]
    else
      # If right array is bigger, then take n elements from it
      sublist = [shorter_array, longer_array.first(n)]
    end
    # Reverse the last array
    sublist[1].reverse!

    is_a_reflection = check_reflection(*sublist)
    # puts "Reflection: #{is_a_reflection}"
    amount = i if is_a_reflection
  end

  amount
end
