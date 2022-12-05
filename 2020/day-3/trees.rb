file = File.read('trees.txt').split("\n")

TREES = []

file.each do |line|
  TREES << line.chars
end
