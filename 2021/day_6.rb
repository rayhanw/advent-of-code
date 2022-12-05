file = File.readlines("day_6.txt")

fishes = file[0].strip.split(",").group_by { |a| a }.map { |k, v| [k.to_i, v.count] }.to_h

9.times do |num|
	fishes[num] = 0 unless fishes.key?(num)
end

def day_passes(fishes)
	hash = Hash.new(0)

	fishes.each do |k, v|
		unless k == 0
			hash[k - 1] = v
		end
	end

	hash[8] = fishes[0]
	hash[6] += fishes[0]

	return hash
end

256.times do
	fishes = day_passes(fishes)	
end

p fishes.values.sum

# class LanternFish
# 	DAYS = 256

# 	attr_reader :timer

# 	def initialize(timer = 8)
# 		@timer = timer
# 		@wait = @timer == 8
# 	end

# 	def cycle!(fishes)
# 		if @timer == 0
# 			@timer = 6
# 			fishes << LanternFish.new
# 		else
# 			@timer -= 1 unless @wait
# 		end

# 		@wait = false
# 	end

# 	class << self
# 		def add_fish(fishes)
# 			fishes << self.new
# 		end
# 	end
# end

# day = 1

# lantern_fishes = []
# file[0].strip.split(",").map(&:to_i).map do |timer|
# 	fish = LanternFish.new(timer)
# 	lantern_fishes << fish
# end

# while day <= LanternFish::DAYS
# 	# SIMULATE FISH BREED
# 	lantern_fishes.each do |f|
# 		f.cycle!(lantern_fishes)
# 	end

# 	puts "Day #{day}: #{lantern_fishes.count} fishes"

# 	day += 1
# end

# p lantern_fishes.count
