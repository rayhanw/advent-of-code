file = File.readlines("input.txt").map(&:chomp)
instructions = []
MAX_STACKS = file.map(&:chomp).find { |line| line.gsub(/\s+/, '').match?(/^\d+$/) }.chomp.gsub(/\s+/, '').chars.last.to_i
stacks = Array.new(MAX_STACKS) { |i| [] }
crates = file.select { |line| line.match?(/\[.\]/) }
lines = []

file.each do |line|
  instructions << line if line[0..3] == "move"
end

crates.each do |crate|
  line = crate.chars.each_slice(4).to_a.map(&:join).map(&:strip)

  if line.size < 3
    (3 - line.size).times do
      line << ""
    end
  end

  lines << line
end

lines = lines.transpose.map do |line|
  line.reject! { |char| char == "" }
  line
end

instructions.each do |ins|
  sep = ins.split
  amount = sep[1].to_i
  from = sep[3].to_i - 1
  to = sep.last.to_i - 1

  p "amount: #{amount}"
  p "from: #{from}"
  p "to: #{to}"
  puts

  moving = lines[from].shift(amount)
  lines[to] = moving + lines[to]
end

p lines.map(&:first).join("").gsub("[", "").gsub("]", "")
