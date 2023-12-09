require_relative '../../helpers/advent_of_code'

aoc = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
file = aoc.file
lol = []
file.each do |f|
  line = f.split(' ').map(&:to_i)
  steps = line.map.with_index do |v, i|
    if i == line.length - 1
      nil
    else
      next_number = line[i + 1]
      next_number - v
    end
  end.compact

  hahaha = [line, steps]

  until steps.all?(&:zero?)
    steps = steps.map.with_index do |v, i|
      if i == steps.length - 1
        nil
      else
        next_number = steps[i + 1]
        next_number - v
      end
    end.compact

    hahaha << steps
  end

  hahaha.reverse!

  hahaha.each_with_index do |haha, i|
    if i.zero?
      haha.unshift(0)
    else
      last_ele = haha.first
      previous_haha_last_ele = hahaha[i - 1].first
      haha.unshift last_ele - previous_haha_last_ele
    end
  end

  lol << hahaha
end

p lol.sum { |l| l.last.first }
