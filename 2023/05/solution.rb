require 'benchmark'
require 'colorized_string'
require_relative '../../helpers/advent_of_code'
require_relative 'helpers'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
seeds = file[0].gsub('seeds: ', '').split(' ').map(&:to_i)

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

seeds.each do |seed|
  info = { seed: }

  # Seed to Soil
  potential_soils = []
  seed_to_soil_map.each do |map|
    diff = seed.to_i - map[:source].to_i
    if diff.negative?
      info[:soil] = seed.to_i
      next
    end
    pot = diff + map[:destination].to_i
    info[:soil] = pot > map[:limit] ? seed.to_i : pot
    potential_soils << { diff:, value: info[:soil] }
  end
  info[:soil] = potential_soils.min_by { |i| i[:diff] }[:value] if potential_soils.length.positive?

  # Soil to Fertilizer
  potential_fertilizers = []
  soil_to_fertilizer_map.each do |map|
    diff = info[:soil] - map[:source].to_i
    if diff.negative?
      info[:fertilizer] = info[:soil]
      next
    end
    pot = diff + map[:destination].to_i
    info[:fertilizer] = pot > map[:limit] ? info[:soil] : pot
    potential_fertilizers << { diff:, value: info[:fertilizer] }
  end
  info[:fertilizer] = potential_fertilizers.min_by { |i| i[:diff] }[:value] if potential_fertilizers.length.positive?

  # Fertilizer to Water
  potential_waters = []
  fertilizer_to_water_map.each do |map|
    diff = info[:fertilizer] - map[:source].to_i
    if diff.negative?
      info[:water] = info[:fertilizer]
      next
    end
    pot = diff + map[:destination].to_i
    info[:water] = pot > map[:limit] ? info[:fertilizer] : pot
    potential_waters << { diff:, value: info[:water] }
  end
  info[:water] = potential_waters.min_by { |i| i[:diff] }[:value] if potential_waters.length.positive?

  # Water to Light
  potential_lights = []
  water_to_light_map.each do |map|
    diff = info[:water] - map[:source].to_i
    if diff.negative?
      info[:light] = info[:water]
      next
    end

    pot = diff + map[:destination].to_i
    info[:light] = pot > map[:limit] ? info[:water] : pot
    potential_lights << { diff:, value: info[:light] }
  end
  info[:light] = potential_lights.min_by { |i| i[:diff] }[:value] if potential_lights.length.positive?

  # Light to Temperature
  potential_temperatures = []
  light_to_temperature_map.each do |map|
    diff = info[:light] - map[:source].to_i
    if diff.negative?
      info[:temperature] = info[:light]
      next
    end

    pot = diff + map[:destination].to_i
    info[:temperature] = pot > map[:limit] ? info[:light] : pot
    potential_temperatures << { diff:, value: info[:temperature] }
  end
  info[:temperature] = potential_temperatures.min_by { |i| i[:diff] }[:value] if potential_temperatures.length.positive?

  # Temperature to Humidity
  potential_humidities = []
  temperature_to_humidity_map.each do |map|
    diff = info[:temperature] - map[:source].to_i
    if diff.negative?
      info[:humidity] = info[:temperature]
      next
    end

    pot = diff + map[:destination].to_i
    info[:humidity] = pot > map[:limit] ? info[:temperature] : pot
    potential_humidities << { diff:, value: info[:humidity] }
  end
  info[:humidity] = potential_humidities.min_by { |i| i[:diff] }[:value] if potential_humidities.length.positive?

  # Humidity to Location
  potential_locations = []
  humidity_to_location_map.each do |map|
    diff = info[:humidity] - map[:source].to_i
    if diff.negative?
      info[:location] = info[:humidity]
      next
    end

    pot = diff + map[:destination].to_i
    info[:location] = pot > map[:limit] ? info[:humidity] : pot
    potential_locations << { diff:, value: info[:location] }
  end
  info[:location] = potential_locations.min_by { |i| i[:diff] }[:value] if potential_locations.length.positive?

  locations << info[:location]
  puts ColorizedString["Seed: #{info[:seed]}, soil #{info[:soil]}, fertilizer #{info[:fertilizer]}, water #{info[:water]}, light #{info[:light]}, temperature #{info[:temperature]}, humidity #{info[:humidity]}, location #{info[:location]}"].colorize(:light_blue)
end

puts ColorizedString["ANSWER: #{locations.min}"].colorize(:green)
