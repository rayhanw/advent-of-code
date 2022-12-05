file = File.readlines("boarding_passes.txt")

BOARDING_PASSES = file.map { |line| line.gsub("\n", "") }
