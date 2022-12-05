file = File.readlines("input.txt").map(&:strip)

MAPPING = {
	"X" => "lose",
	"Y" => "draw",
	"Z" => "win"
}
CONDITION_MAPPING = {
	"A" => {
		"draw" => "X",
		"lose" => "Y",
		"win" => "Z"
	},
	"B" => {
		"win" => "X",
		"draw" => "Y",
		"lose" => "Z"
	},
	"C" => {
		"lose" => "X",
		"win" => "Y",
		"draw" => "Z"
	}
}
SCORE_MAPPING = {
	"rock" => 1,
	"paper" => 2,
	"scissor" => 3
}
CHOICE_MAPPING = {
	"A" => "rock",
	"B" => "paper",
	"C" => "scissor",
	"X" => "rock",
	"Y" => "paper",
	"Z" => "scissor"
}
score = 0
file.each do |round|
	game = round.split(" ")
	opponent = game[0]
	condition = game[1]

	if condition == "X"
		puts "NEED TO LOSE"
		chosen = CHOICE_MAPPING[CONDITION_MAPPING[opponent]["win"]]
		score += SCORE_MAPPING[chosen] + 0
	elsif condition == "Y"
		puts "NEED TO DRAW"
		chosen = CHOICE_MAPPING[CONDITION_MAPPING[opponent]["draw"]]
		chosen_score = SCORE_MAPPING[chosen]
		score += SCORE_MAPPING[chosen] + 3
	elsif condition == "Z"
		puts "NEED TO WIN"
		chosen = CHOICE_MAPPING[CONDITION_MAPPING[opponent]["lose"]]
		score += SCORE_MAPPING[chosen] + 6
	end
	puts
end

puts score
