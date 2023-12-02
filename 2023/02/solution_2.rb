require 'colorized_string'

file = File.readlines("input.txt").map(&:strip)

RED_MAX = 12
GREEN_MAX = 13
BLUE_MAX = 14

game = {}
file.each do |line|
  game_id = line.match(/Game (?<id>\d+):/)[:id]
  sets = line.split(';')
  game[game_id] = true
  red_max = 0
  blue_max = 0
  green_max = 0

  sets.map! { |set| set.gsub("Game #{game_id}:", "")}.map(&:strip!)
  sets.each do |set|
    p set
    red = set.match(/(?<digit>\d+) red/) || { match: 0 }
    blue = set.match(/(?<digit>\d+) blue/) || { match: 0 }
    green = set.match(/(?<digit>\d+) green/) || { match: 0 }
    red_max = red[:digit].to_i if red_max < red[:digit].to_i
    blue_max = blue[:digit].to_i if blue_max < blue[:digit].to_i
    green_max = green[:digit].to_i if green_max < green[:digit].to_i
  end
  game[game_id] = { red: red_max, blue: blue_max, green: green_max, combined: red_max * blue_max * green_max }
  puts
end

sum = []
game.each do |id, v|
  puts "GAME #{id}"
  puts "\s- RED: #{v[:red]}"
  puts "\s- BLUE: #{v[:blue]}"
  puts "\s- GREEN: #{v[:green]}"
  puts ColorizedString["\s- TOTAL: #{v[:combined]}"].colorize(:green)
  puts
  sum << v[:combined]
end

puts "ANSWER: #{sum.sum}"

# puts
# ids = []
# game.each do |id, v|
#   p "RED: #{v[:red]}"
#   p "GREEN: #{v[:green]}"
#   p "BLUE: #{v[:blue]}"
#   if v[:red] <= RED_MAX && v[:green] <= GREEN_MAX && v[:blue] <= BLUE_MAX
#     ids << id.to_i
#     puts "Game #{id}: #{ColorizedString["OK"].colorize(:green)}"
#   else
#     puts "Game #{id}: #{ColorizedString["FAIL"].colorize(:red)}"
#   end
#   puts
# end

# puts "ANSWER: #{ids.sum}"
