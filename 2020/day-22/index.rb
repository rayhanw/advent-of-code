file = File.readlines("index.txt")
file = file.map(&:strip).reject(&:empty?)
player_2_index = file.index("Player 2:")
player_1 = file[1..(player_2_index - 1)].map(&:to_i)
player_2 = file[(player_2_index + 1)..-1].map(&:to_i)

index = 1
game = 1

def print_info(player_1, player_2, card_1, card_2, index, game)
	puts "-- Round #{index} (Game #{game}) --"
	puts "Player 1's deck: #{player_1.join(", ")}"
	puts "Player 2's deck: #{player_2.join(", ")}"
	puts "Player 1 plays: #{card_1}"
	puts "Player 2 plays: #{card_2}"

	puts "Player #{card_1 > card_2 ? "1" : "2"} wins the round!"
	puts
end

def print_post_game(player_1, player_2)
	puts "== Post-game results =="
	puts "Player 1's deck: #{player_1.join(", ")}"
	puts "Player 2's deck: #{player_2.join(", ")}"
end

def add_cards(player_1, player_2, card_1, card_2)
	winner_card = card_1 > card_2 ? player_1.shift : player_2.shift
	loser_card = card_1 < card_2 ? player_1.shift : player_2.shift

	if card_1 > card_2
		player_1 << winner_card
		player_1 << loser_card
	else
		player_2 << winner_card
		player_2 << loser_card
	end
end

def calculate_result(deck)
	score = 0
	deck.reverse.each_with_index do |card, index|
		amount = card * (index + 1)
		score += amount
	end

	puts score
end

until [player_1.size, player_2.size].include? 0
	card_1 = player_1[0]
	card_2 = player_2[0]

	print_info(player_1, player_2, card_1, card_2, index, game)
	add_cards(player_1, player_2, card_1, card_2)

	index += 1
	if false
		game += 1
	end
end

print_post_game(player_1, player_2)
calculate_result(player_1.size > player_2.size ? player_1 : player_2)
