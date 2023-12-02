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

  sets.map! { |set| set.gsub("Game #{game_id}:", "")}.map(&:strip!)
  sets.each do |set|
    red = set.match(/(?<digit>\d+) red/)
    blue = set.match(/(?<digit>\d+) blue/)
    green = set.match(/(?<digit>\d+) green/)
    colors = {}
    colors[:red] = red[:digit] if red
    colors[:green] = green[:digit] if green
    colors[:blue] = blue[:digit] if blue
    colors.each do |k, v|
      if (k == :red && v.to_i > RED_MAX) || (k == :blue && v.to_i > BLUE_MAX) || (k == :green && v.to_i > GREEN_MAX)
        game[game_id] = false
        break
      end
    end
    puts
  end
end

ids = []
game.each do |id, v|
  if v
    ids << id.to_i
    puts "Game #{id}: #{ColorizedString["OK"].colorize(:green)}"
  else
    puts "Game #{id}: #{ColorizedString["FAIL"].colorize(:red)}"
  end
end

puts "ANSWER: #{ids.sum}"

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
