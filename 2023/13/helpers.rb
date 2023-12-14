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

def check_for_smudge(array, other)
  condensed_array = array.join('')
  condensed_other = other.join('')
  differences = []
  condensed_array.size.times do |i|
    differences << (condensed_array[i] == condensed_other[i])
    return false if differences.count(false) > 1
  end

  return true if differences.count(false) == 1

  false
end

def count_reflection(pattern, type = nil, collection:, part:, should_print: false)
  amount = 0
  (1..(pattern.size - 1)).to_a.each do |i|
    # break if collection.size.positive? && part == 2

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
    if part == 2
      # Check for smudge
      has_smudge = check_for_smudge(*sublist)
      if is_a_reflection || has_smudge
        puts
        puts sublist[0].join(' ')
        puts sublist[1].join(' ')
        color = is_a_reflection ? :green : :red
        puts ColorizedString["Splitting at #{i} and #{i + 1} on #{type}"].colorize(:yellow)
        puts "Reflection: #{ColorizedString["#{is_a_reflection}"].colorize(color)}"
        puts "Fixable by smudge: #{ColorizedString["#{has_smudge}"].colorize(has_smudge ? :green : :red)}"
      end

      # If there is a smudge, then we can fix it
      if has_smudge
        amount = i
        collection << { i:, type: }
      end
    end

    if part == 1
      puts "Reflection: #{ColorizedString["#{is_a_reflection}"].colorize(color)}"
      amount = i if is_a_reflection
      next
    end
  end

  amount
end
