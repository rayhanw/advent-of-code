require 'benchmark'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
seeds = file[0].gsub('seeds: ', '').split(' ').map(&:to_i)
puts "--- Generated seeds ---"

### Seed to Soil ###
seed_to_soil_map = generate_map(file, 'seed-to-soil map:')
# print_map(seed_to_soil_map, 'Seed to Soil')
puts "--- Generated seed to soil map ---"

### Soil to Fertilizer ###
soil_to_fertilizer_map = generate_map(file, 'soil-to-fertilizer map:')
# print_map(soil_to_fertilizer_map, 'Soil to Fertilizer')
puts "--- Generated soil to fertilizer map ---"

### Fertilizer to Water ###
fertilizer_to_water_map = generate_map(file, 'fertilizer-to-water map:')
# print_map(fertilizer_to_water_map, 'Fertilizer to Water')
puts "--- Generated fertilizer to water map ---"

### Water to Light ###
water_to_light_map = generate_map(file, 'water-to-light map:')
# print_map(water_to_light_map, 'Water to Light')
puts "--- Generated water to light map ---"

### Light to Temperature ###
light_to_temperature_map = generate_map(file, 'light-to-temperature map:')
# print_map(light_to_temperature_map, 'Light to Temperature')
puts "--- Generated light to temperature map ---"

### Temperature to Humidity ###
temperature_to_humidity_map = generate_map(file, 'temperature-to-humidity map:')
# print_map(temperature_to_humidity_map, 'Temperature to Humidity')
puts "--- Generated temperature to humidity map ---"

### Humidity to Location ###
humidity_to_location_map = generate_map(file, 'humidity-to-location map:')
# print_map(humidity_to_location_map, 'Humidity to Location')
puts "--- Generated humidity to location map ---"

puts "Seeds: #{seeds}"
complete_info = []
seeds.each do |seed|
  info = {}
  # Seed to Soil
  soil_index = seed_to_soil_map[:sources].index(seed)
  soil = seed
  soil = seed_to_soil_map[:destinations][soil_index] if soil_index
  # Soil to Fertilizer
  fertilizer_index = soil_to_fertilizer_map[:sources].index(soil)
  fertilizer = soil
  fertilizer = soil_to_fertilizer_map[:destinations][fertilizer_index] if fertilizer_index
  # Fertilizer to Water
  water_index = fertilizer_to_water_map[:sources].index(fertilizer)
  water = fertilizer
  water = fertilizer_to_water_map[:destinations][water_index] if water_index
  # Water to Light
  light_index = water_to_light_map[:sources].index(water)
  light = water
  light = water_to_light_map[:destinations][light_index] if light_index
  # Light to Temperature
  temperature_index = light_to_temperature_map[:sources].index(light)
  temperature = light
  temperature = light_to_temperature_map[:destinations][temperature_index] if temperature_index
  # Temperature to Humidity
  humidity_index = temperature_to_humidity_map[:sources].index(temperature)
  humidity = temperature
  humidity = temperature_to_humidity_map[:destinations][humidity_index] if humidity_index
  # Humidity to Location
  location_index = humidity_to_location_map[:sources].index(humidity)
  location = humidity
  location = humidity_to_location_map[:destinations][location_index] if location_index

  info[:seed] = seed
  info[:soil] = soil
  info[:fertilizer] = fertilizer
  info[:water] = water
  info[:light] = light
  info[:temperature] = temperature
  info[:humidity] = humidity
  info[:location] = location
  complete_info << info
  puts "Seed #{seed}, soil #{soil}, fertilizer #{fertilizer}, water #{water}, light #{light}, temperature #{temperature}, humidity #{humidity}, location #{location}"
end

sorted = complete_info.sort_by { |i| i[:location] }
lowest = sorted[0]
puts "Lowest location: #{lowest[:location]}"
