require 'colorized_string'

def generate_map(file, key)
  start_index = file.index(key)
  maps = file[(start_index + 1)..]
  end_index = maps.index('')
  maps = maps[0...end_index]
  maps.map do |map|
    list = map.split(' ')
    {
      destination: list[0].to_i,
      source: list[1].to_i,
      range: list[2].to_i,
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

def transform(seed_range, mappings)
  min = seed_range[0]
  max = seed_range[0] + seed_range[1] - 1
  # puts "min=#{min}"
  # puts "max=#{max}"
  # 1. Check if `min` is in range of any mapping's `limit`
  # TODO: Handle when there's no min/max mapping (it should map to itself).
  # Maybe can return early?
  min_mapping = mappings.find do |mapping|
    is_positive = (min - mapping[:source]) >= 0
    range = (mapping[:source]..mapping[:source]+mapping[:range]-1)
    is_in_range = range.cover?(min)

    is_positive && is_in_range
  end
  max_mapping = mappings.find do |mapping|
    is_positive = (max - mapping[:source]) >= 0
    range = (mapping[:source]..mapping[:source]+mapping[:range]-1)
    is_in_range = range.cover?(max)

    is_positive && is_in_range
  end

  if min_mapping
    # Handle `min`
    next_min = min - min_mapping[:source] + min_mapping[:destination]
  else
    next_min = min
  end

  if max_mapping
    # Handle `max`
    next_max = max - max_mapping[:source] + max_mapping[:destination]
  else
    next_max = max
  end

  diff = next_max - next_min

  # (next_min..(next_min + diff))
  [next_min, diff + 1]
end

def run_flow(range, seed_to_soil_map:, soil_to_fertilizer_map:, fertilizer_to_water_map:, water_to_light_map:, light_to_temperature_map:, temperature_to_humidity_map:, humidity_to_location_map:, locations:)
  # puts "seed-to-soil:"
  soil_range = transform(range, seed_to_soil_map)
  # puts "soil-to-fertilizer:"
  fertilizer_range = transform(soil_range, soil_to_fertilizer_map)
  # puts "fertilizer-to-water:"
  water_range = transform(fertilizer_range, fertilizer_to_water_map)
  # puts "water-to-light:"
  light_range = transform(water_range, water_to_light_map)
  # puts "light-to-temperature:"
  temperature_range = transform(light_range, light_to_temperature_map)
  # puts "temperature-to-humidity:"
  humidity_range = transform(temperature_range, temperature_to_humidity_map)
  # puts "humidity-to-location:"
  location_range = transform(humidity_range, humidity_to_location_map)
  # puts "location: #{[location_range[0], location_range[0]+location_range[1]-1]}"
  locations << [location_range[0], location_range[0]+location_range[1]-1]
  nil
end
