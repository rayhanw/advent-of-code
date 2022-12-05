instructions = File.readlines("index.txt").map(&:strip)

DIRECTIONS = %w[E S W N]
FULL_ROTATION = 360
direction = "E"
position = {
	"E" => 0,
	"N" => 0,
	"S" => 0,
	"W" => 0
}

def new_direction(direction, degrees)
	amount = FULL_ROTATION / degrees
	DIRECTIONS[(amount % DIRECTIONS.length) + 1]
end

instructions.each do |instruction|
	action = instruction[0]
	amount = instruction[1..-1].to_i

	if action == "F"
		position[direction] += amount
	elsif action == "N"
		if action != direction
			position[action] += amount
		end
	elsif action == "R"
		direction = new_direction(direction, amount)
	end
end

p position
