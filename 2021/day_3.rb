def calculate(rating)
	file = File.readlines("day_3.txt").map(&:strip).map { |char| char.split("") }
	ite = 0

	until file.length == 1
		pos = file.map { |line| line[ite] }
		zero_count = pos.count("0")
		one_count = pos.count("1")
		if rating == "oxygen"
			file.filter! { |line| line[ite] == (zero_count <= one_count ? "1" : "0") }
		else
			file.filter! { |line| line[ite] == (zero_count > one_count ? "1" : "0") }
		end
		ite += 1
	end

	file.flatten.join("").to_i(2)
end

oxy = calculate("oxygen")
o2 = calculate("o2")
p "oxy: #{oxy} | o2: #{o2} | life support: #{oxy * o2}"
