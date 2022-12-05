file = File.readlines("day_12.txt").map(&:strip)
node = file.map { |line| line.split("-") }

p node
