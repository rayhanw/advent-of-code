require 'colorized_string'

def generate_map(file, key)
  start_index = file.index(key)
  maps = file[(start_index + 1)..]
  end_index = maps.index('')
  maps = maps[0...end_index]
  maps.map do |map|
    list = map.split(' ')
    {
      destination: list[0],
      source: list[1],
      range: list[2],
      limit: list[0].to_i + list[2].to_i
    }
  end
end

def print_map(map, title)
  puts ColorizedString[title.upcase].colorize(:red)
  puts ColorizedString["Sources"].colorize(:light_blue)
  puts "#{map[:sources]}"
  puts ColorizedString["Destinations"].colorize(:light_green)
  puts "#{map[:destinations]}"
  puts
end
