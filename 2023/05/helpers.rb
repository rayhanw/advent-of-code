require 'colorized_string'

def generate_map(file, key)
  start_index = file.index(key)
  maps = file[(start_index + 1)..]
  end_index = maps.index('')
  maps = maps[0...end_index]
  result = maps.map do |map|
    list = map.split(' ')
    source_values = (list[1].to_i..(list[1].to_i + list[2].to_i)).to_a
    destination_values = (list[0].to_i..(list[0].to_i + list[2].to_i)).to_a
    {
      destination: list[0],
      source: list[1],
      range: list[2],
      source_values:,
      destination_values:
    }
  end

  sources = result.map { |r| r[:source_values] }.flatten
  destinations = result.map { |r| r[:destination_values] }.flatten

  { sources:, destinations: }
end

def print_map(map, title)
  puts ColorizedString[title.upcase].colorize(:red)
  puts ColorizedString["Sources"].colorize(:light_blue)
  puts "#{map[:sources]}"
  puts ColorizedString["Destinations"].colorize(:light_green)
  puts "#{map[:destinations]}"
  puts
end
