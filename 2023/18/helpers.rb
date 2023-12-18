def fill_between_hashes(arrays)
  arrays.map do |row|
    in_segment = false
    new_row = row.map do |element|
      if element == '#'
        in_segment = !in_segment
        element
      elsif in_segment
        '#'
      else
        element
      end
    end
    # Handle case where a row ends while still in a segment
    new_row.reverse.map! { |e| e == '.' && in_segment ? '#' : e }.reverse
  end
end
