m = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

m.each do |l|
  puts l.join(' ')
end
puts '---------------------'
m.transpose.reverse.each do |l|
  puts l.join(' ')
end
