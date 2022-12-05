file = File.readlines("day_7.txt")
numbers = file[0].strip.split(",").map(&:to_i)

trips = []
try = 0
while try < numbers.max
	fuels = []
	numbers.each do |num|
		cost = 1
		diff = (num - try).abs
		amount = 0
		diff.times do
			amount += cost
			cost += 1
		end
		fuels << amount
	end

	trips << fuels

	try += 1
end

pp trips
p trips.map(&:sum)
p trips.map(&:sum).sort
