require 'colorized_string'

def print_space(space, highlight_index = nil)
  space.each_with_index do |row, row_index|
    row.each do |column|
      if highlight_index && row_index == highlight_index
        print ColorizedString[column].colorize(:green)
      else
        print column
      end
      print ' '
    end
    puts
  end
end
