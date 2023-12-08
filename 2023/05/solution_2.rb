require 'benchmark'
require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
seeds = file[0].gsub('seeds: ', '').split(' ').map(&:to_i).each_slice(2).to_a.map { |slice| [slice[0], slice[1]] }
seeds.each do |seed|
  puts ColorizedString["Seed #{seed[0]}, range #{seed[1]}"].colorize(:green)
end
puts

### Seed to Soil ###
seed_to_soil_map = generate_map(file, 'seed-to-soil map:')
### Soil to Fertilizer ###
soil_to_fertilizer_map = generate_map(file, 'soil-to-fertilizer map:')
### Fertilizer to Water ###
fertilizer_to_water_map = generate_map(file, 'fertilizer-to-water map:')
### Water to Light ###
water_to_light_map = generate_map(file, 'water-to-light map:')
### Light to Temperature ###
light_to_temperature_map = generate_map(file, 'light-to-temperature map:')
### Temperature to Humidity ###
temperature_to_humidity_map = generate_map(file, 'temperature-to-humidity map:')
### Humidity to Location ###
humidity_to_location_map = generate_map(file, 'humidity-to-location map:')

locations = []
locations_two = []
locations_three = []
seeds.each do |seed|
  run_flow(seed, seed_to_soil_map:, soil_to_fertilizer_map:, fertilizer_to_water_map:, water_to_light_map:, light_to_temperature_map:, temperature_to_humidity_map:, humidity_to_location_map:, locations:)
end
p locations
locations.each do |seed|
  run_flow(seed, seed_to_soil_map:, soil_to_fertilizer_map:, fertilizer_to_water_map:, water_to_light_map:, light_to_temperature_map:, temperature_to_humidity_map:, humidity_to_location_map:, locations: locations_two)
end
p locations_two
locations_two.each do |seed|
  run_flow(seed, seed_to_soil_map:, soil_to_fertilizer_map:, fertilizer_to_water_map:, water_to_light_map:, light_to_temperature_map:, temperature_to_humidity_map:, humidity_to_location_map:, locations: locations_three)
end
p locations_three
# seeds.each do |seed|
#   puts "seed-to-soil:"
#   soil_range = transform(seed, seed_to_soil_map)
#   puts "soil-to-fertilizer:"
#   fertilizer_range = transform(soil_range, soil_to_fertilizer_map)
#   puts "fertilizer-to-water:"
#   water_range = transform(fertilizer_range, fertilizer_to_water_map)
#   puts "water-to-light:"
#   light_range = transform(water_range, water_to_light_map)
#   puts "light-to-temperature:"
#   temperature_range = transform(light_range, light_to_temperature_map)
#   puts "temperature-to-humidity:"
#   humidity_range = transform(temperature_range, temperature_to_humidity_map)
#   puts "humidity-to-location:"
#   location_range = transform(humidity_range, humidity_to_location_map)
#   puts "location: #{[location_range[0], location_range[0]+location_range[1]-1]}"
#   seeds_v2 << location_range
#   puts
# end
# puts "--------------------------------------------------------------------------"
# seeds_v3 = []
# seeds_v2.each do |seed|
#   puts "seed-to-soil:"
#   soil_range = transform(seed, seed_to_soil_map)
#   puts "soil-to-fertilizer:"
#   fertilizer_range = transform(soil_range, soil_to_fertilizer_map)
#   puts "fertilizer-to-water:"
#   water_range = transform(fertilizer_range, fertilizer_to_water_map)
#   puts "water-to-light:"
#   light_range = transform(water_range, water_to_light_map)
#   puts "light-to-temperature:"
#   temperature_range = transform(light_range, light_to_temperature_map)
#   puts "temperature-to-humidity:"
#   humidity_range = transform(temperature_range, temperature_to_humidity_map)
#   puts "humidity-to-location:"
#   location_range = transform(humidity_range, humidity_to_location_map)
#   puts "location: #{[location_range[0], location_range[0]+location_range[1]-1]}"
#   seeds_v3 << location_range
#   puts
# end
# puts "--------------------------------------------------------------------------"
# seeds_v3.each do |seed|
#   puts "seed-to-soil:"
#   soil_range = transform(seed, seed_to_soil_map)
#   puts "soil-to-fertilizer:"
#   fertilizer_range = transform(soil_range, soil_to_fertilizer_map)
#   puts "fertilizer-to-water:"
#   water_range = transform(fertilizer_range, fertilizer_to_water_map)
#   puts "water-to-light:"
#   light_range = transform(water_range, water_to_light_map)
#   puts "light-to-temperature:"
#   temperature_range = transform(light_range, light_to_temperature_map)
#   puts "temperature-to-humidity:"
#   humidity_range = transform(temperature_range, temperature_to_humidity_map)
#   puts "humidity-to-location:"
#   location_range = transform(humidity_range, humidity_to_location_map)
#   puts "location: #{[location_range[0], location_range[0]+location_range[1]-1]}"
#   locations << location_range
#   puts
# end
# puts "--------------------------------------------------------------------------"
# p locations.min_by { |slice| slice[0] }
