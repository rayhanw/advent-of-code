file = File.readlines("input.txt").map(&:strip)

##
# SCORING:
#
# Rock -> 1
# Paper -> 2
# Scissor -> 3
#
# Outcome of round:
# Lost -> 0
# Draw -> 3
# Win -> 6
#
# STRATEGY GUIDE:
# Win -> Lose -> Draw
##

score = 0

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
MAPPINGS = {
	"A" => {
		"X" => "draw",
		"Y" => "lose",
		"Z" => "win"
	},
	"B" => {
		"X" => "win",
		"Y" => "draw",
		"Z" => "lose"
	},
	"C" => {
		"X" => "lose",
		"Y" => "win",
		"Z" => "draw"
	}
}
OPP_MAPPING = {
	"X" => {
		"A" => "draw",
		"B" => "lose",
		"C" => "win"
	},
	"Y" => {
		"A" => "win",
		"B" => "draw",
		"C" => "lose"
	},
	"Z" => {
		"A" => "lose",
		"B" => "win",
		"C" => "draw"
	}
}

file.each do |round|
	game = round.split(" ")
	opponent = game[0]
	mine = game[1]
	chosen = CHOICE_MAPPING[mine]
	outcome = OPP_MAPPING[mine][opponent]
	choice_add = SCORE_MAPPING[chosen]
	
	if outcome == "win"
		score += choice_add + 6
	elsif outcome == "lose"
		score += choice_add + 0
	elsif outcome == "draw"
		score += choice_add + 3
	end
end

p score
