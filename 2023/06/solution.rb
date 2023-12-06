require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
races = {}
times = file[0].gsub('Time:', '').strip.split(' ').map(&:to_i)
distances = file[1].gsub('Distance:', '').strip.split(' ').map(&:to_i)

times.length.times do |i|
  races[i + 1] = { time: times[i], distance: distances[i], possibilities: [] }
end

possibilities_count = races.map do |_, race|
  (race[:time] + 1).times do |i|
    hold_time = i
    possibility = {
      hold: hold_time,
      travelled: (race[:time] - hold_time) * hold_time
    }
    race[:possibilities] << possibility if possibility[:travelled] > race[:distance]
  end

  race[:possibilities].uniq.length
end

p possibilities_count.inject(:*)
