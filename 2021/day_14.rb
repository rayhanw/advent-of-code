file = File.readlines("day_14.txt").map(&:strip)

def part_1(file)
	template = file[0]

	10.times do
		instructions = file[2..-1].map { |ins| ins.split(" -> ") }
		used = []
		pair = template.chars.each_cons(2).map(&:join)
		set = instructions.filter { |ins| pair.include? ins[0] }

		pair = pair.map.with_index do |combo, idx|
			instruction = set.find { |ele| ele[0] == combo }
			[combo[0], instruction[1], combo[1]]
		end

		pair = pair.map.with_index do |pa, idx|
			if idx.zero?
				pa
			else
				pa[1..-1]
			end
		end

		template = pair.flatten.join
	end

	pairs = template.chars.group_by(&:itself).map { |k, v| [k, v.count] }.sort_by { |ary| -ary[1] }
	max = pairs[0][1]
	min = pairs[-1][1]

	p max - min
end

def part_2(file)
	counter = Hash.new(0)
	file[0].chars.each_cons(2).map(&:join).each { |set| counter[set] += 1 }
	instructions = file[2..-1].map { |ins| ins.split(" -> ") }.to_h
	mappings = {}
	instructions.each do |k, v|
		key_1 = "#{k[0]}#{v}"
		key_2 = "#{v}#{k[1]}"
		mappings[k] = [key_1, key_2]
	end

	new_counter = Hash.new(0)
	40.times do
		counter.each do |k, v|
			mapping = mappings[k]
			new_counter[mapping[0]] += v
			new_counter[mapping[1]] += v
		end

		counter = new_counter
		new_counter = Hash.new(0)
	end

	single = Hash.new(0)

	counter.each do |k, v|
		k.chars.each do |char|
			single[char] += v
		end
	end

	sorted = single.sort_by { |k, v| -v }
	max = sorted[0][1] / 2
	min = sorted[-1][1] / 2
	p (max - min) - 1
end

part_2(file)
