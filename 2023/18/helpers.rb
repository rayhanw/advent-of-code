def fill_between_hashes(arrays)
  arrays.each do |ary|
    idx_start = ary.index('#')
    idx_end = ary.rindex('#')
    next if idx_start.nil? || idx_end.nil?

    idx_start += 1
    (idx_start...idx_end).each do |i|
      ary[i] = '#'
    end
  end

  arrays
end
