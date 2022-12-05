class DayEight
	def initialize
		file = File.readlines("instructions.txt")

		@instructions = []

		file.each do |line|
			instruction = []
			instruction_line = line.strip.split
			instruction[0] = instruction_line[0]
			instruction[1] = instruction_line[1].gsub(/(\+)/, '').to_i
			@instructions << instruction
		end

		@accumulator = 0
		@index = 0
		@last_index = @instructions.length - 1
		@indexes = []
		@changed = false
		@running = true
		@commands_run = []
		@cpy = @instructions.clone
		@skip = 0
	end

	def jump(ins)
		@index += ins[1]
		if @indexes.include?(@index)
			@running = false
		else
			@indexes << @index
		end
	end

	def accumulate(ins)
		@accumulator += ins[1]
		@indexes << @index
		@index += 1
	end

	def exec(ins)
		case ins[0]
		when 'acc'
			accumulate(ins)
		when 'jmp'
			jump(ins)
		when 'nop'
			@index += 1
		end

		@commands_run << ins
	end

	def big_run
		changed = false
		@cpy.each_with_index do |ins, idx|
			if ins[0] == 'nop' && !changed
				@cpy[idx][0] = 'jmp'
				changed = true
			elsif ins[0] == 'jmp' && !changed
				@cpy[idx][0] = 'nop'
				changed = true
			end
		end

		run
	end

	def run
		while @running do
			ins = @cpy[@index]

			exec(ins)
		end
	end
end

eight = DayEight.new
eight.big_run

p eight
