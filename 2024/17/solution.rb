require "csv"
require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)
FILEPATH = "data/outputs.csv"

### --- Day 17: Chronospatial Computer ---
COMBO_OPERANDS = {
  "0" => 0,
  "1" => 1,
  "2" => 2,
  "3" => 3,
  "4" => ->(registers) { registers["A"] },
  "5" => ->(registers) { registers["B"] },
  "6" => ->(registers) { registers["C"] },
  "7" => nil
}.freeze

def run_program(opcode, operand, registers, programs, outputs)
  combo_command = COMBO_OPERANDS[operand]

  # rubocop:disable Style/CaseLikeIf
  if opcode == "0" # ✅
    numerator = registers["A"]
    combo_value = if combo_command.is_a?(Integer)
                    combo_command
                  elsif %(4 5 6).include?(operand)
                    combo_command.call(registers)
                  end
    denominator = 2**combo_value
    registers["A"] = numerator / denominator
    nil
  elsif opcode == "1" # ✅
    value = registers["B"] ^ operand.to_i
    registers["B"] = value
    nil
  elsif opcode == "2" # ✅
    value = if combo_command.is_a?(Integer)
              combo_command
            elsif %(4 5 6).include?(operand)
              combo_command.call(registers)
            else
              # Impossible scenario
              # puts "This scenario should not exist (in P1 at least)"
            end
    registers["B"] = value % 8
    nil
  elsif opcode == "3"
    return nil if registers["A"].zero?

    new_programs = programs[operand.to_i..]
    new_programs.each_slice(2).each do |(opcode, operand)|
      # puts "Running program: #{opcode} -> #{operand}"
      value = run_program(opcode, operand, registers, programs, outputs)
      outputs << value if value
    end
    nil
  elsif opcode == "4" # ✅
    value = registers["B"] ^ registers["C"]
    registers["B"] = value
    nil
  elsif opcode == "5" # ✅
    value = if combo_command.is_a?(Integer)
              combo_command
            elsif %(4 5 6).include?(operand)
              combo_command.call(registers)
            end
    # puts "  Received output value: #{value % 8}".colorize(:magenta)
    value % 8
  elsif opcode == "6" # ✅
    numerator = registers["A"]
    combo_value = if combo_command.is_a?(Integer)
                    combo_command
                  elsif %(4 5 6).include?(operand)
                    combo_command.call(registers)
                  end
    denominator = 2**combo_value
    registers["B"] = numerator / denominator
    nil
  elsif opcode == "7" # ✅
    numerator = registers["A"]
    combo_value = if combo_command.is_a?(Integer)
                    combo_command
                  elsif %(4 5 6).include?(operand)
                    combo_command.call(registers)
                  end
    denominator = 2**combo_value
    registers["C"] = numerator / denominator
    nil
  end
  # rubocop:enable Style/CaseLikeIf
end

def run_whole_program_sequence(programs, registers)
  outputs = []
  programs.each_slice(2).each do |(opcode, operand)|
    # puts "Running program: #{opcode} -> #{operand}"
    value = run_program(opcode, operand, registers, programs, outputs)
    outputs << value if value
  end

  # registers.each do |label, value|
  #   puts "#{label}: #{value}"
  # end

  # puts "Outputs: #{outputs.join(',')}".colorize(:green)

  outputs
end

def brute_force_register_a_value(programs)
  possibilities = (0..15).each_with_object({}) { |k, h| h[k] = [] }

  key = 15
  lower_bound = 8**key
  upper_bound = 8**(key + 1)
  step = 8**key
  candidates = (lower_bound...upper_bound).step(step).to_a
  candidates.each do |candidate|
    output = run_whole_program_sequence(programs, { "A" => candidate, "B" => 0, "C" => 0 })
    possibilities[key] << { min: candidate, max: candidate + step } if output[key] == programs[key].to_i
  end

  (0...15).to_a.reverse_each do |key|
    possibilities[key + 1].each do |possibility|
      lower_bound = possibility[:min]
      upper_bound = possibility[:max]
      step = 8**key
      candidates = (lower_bound...upper_bound).step(step).to_a
      candidates.each do |candidate|
        output = run_whole_program_sequence(programs, { "A" => candidate, "B" => 0, "C" => 0 })
        possibilities[key] << { min: candidate, max: candidate + step, output: } if output[key] == programs[key].to_i
      end
    end
  end

  possibilities[0].min_by { |possibility| possibility[:min] }
end

time = Benchmark.realtime do
  registers = {}
  programs = []

  FILE.each do |line|
    if line.start_with?("Register")
      register, value = line.split(" ")[1..-1]
      registers[register[0..-2]] = value.to_i
    elsif line.start_with?("Program")
      programs << line.split(" ")[1].split(",")
    end
  end
  programs.flatten!
  # puts "Programs: #{programs.join(',')}".colorize(:light_green)
  answer = brute_force_register_a_value(programs)
  puts "Answer: #{answer[:min]}".colorize(:green)
end

puts
puts "Time: #{time.round(2)}".colorize(:red)
