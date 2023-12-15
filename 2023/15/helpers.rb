def determine_box(text)
  iterator = 0
  text.each_byte do |c|
    iterator += c
    iterator *= 17
    iterator %= 256
  end

  iterator
end

def print_boxes(boxes)
  boxes.each_with_index do |box, i|
    next if box.empty?

    mapped = box.map { |b| b.split('=').join(' ') }
    puts "Box #{i}: [#{mapped.join(' ')}]"
  end
end

def strip_special_characters(text)
  text.gsub(/\W+/, '')
end

def lens_index(boxes, query)
  boxes.each_with_index do |box, i|
    box.each_with_index do |lens, j|
      if lens.start_with?(query)
        label, _value = lens.split('=')
      end
      return { outer: i, inner: j } if label == query
    end
  end

  nil
end
