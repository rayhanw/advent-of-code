$counter = 0

def check_hot_spring(springs, hints)
  puts springs.chars.join(' ')
  if springs.start_with?('.')
    # discard the . and recursively check again.
    check_hot_spring(springs[1..], hints)
  elsif springs.start_with?('?')
    # replace the ? with a .
    springs[0] = '.'
    # and recursively check again
    check_hot_spring(springs, hints)
    # AND replace it with a #
    springs[0] = '#'
    # and recursively check again.
    check_hot_spring(springs, hints)
  elsif springs.start_with?('#')
    # Find first non-. character after the index 0
    substring = springs[1..]
    index = substring.chars.find_index { |char| char != '.' } + 1
    # check if it is long enough for the first group
    sublist = substring[0..index]
    if sublist.length < hints[0] && sublist.all? { |char| char != '.' }
      check_hot_spring(springs[index..], hints[1..])
    end
  elsif springs == ''
    puts "EMPTY"
  end
end

def generate_variations(springs, hints)
end
