file = File.read("answers.txt").split("\n\n")

GROUPS = []
SECOND_GROUP = []

file.each do |line|
  GROUPS << line.gsub("\n", "")
end

file.each do |line|
  group = line.split("\n\n")
  group.map! { |g| g.split("\n") }
  SECOND_GROUP << group[0]
end
