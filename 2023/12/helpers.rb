=begin
  springs String
  arrangement Array<Integer>
=end

def generate_combinations(springs, arrangement)
  # Base case: If there are no `?` left, return the current string
  unless springs.include?('?')
    # Handle logic to validate the string against the arrangement
    return valid?(springs, arrangement) ? [springs] : []
  end

  # Recursive case: Replace the first `?` with `#` and `.`
  combinations = []
  %w[# .].each do |replacement|
    new_springs = springs.sub('?', replacement)
    combinations.concat(generate_combinations(new_springs, arrangement))
  end

  combinations
end

def valid?(springs, arrangement)
  splitted = springs.split('.').reject(&:empty?)

  # Case 1: The arrangement size is different than springs size
  return false if splitted.size != arrangement.size

  # Case 2: [Multiple routes] Arrangement size is equal to springs size
  ### Pseudocode:
  # 1. Iterate over `splitted`
  # 2. For each element, check if the amount of `#` is equal to the arrangement at the same index
  # 3. If it is, continue
  # 4. If it is not, return false
  ###
  splitted.each_with_index do |item, idx|
    hash_count = item.count('#')
    current_arrangement = arrangement[idx]

    return false if hash_count != current_arrangement
  end

  true
end
