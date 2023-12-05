require 'digest'
require_relative '../../helpers/advent_of_code'

AOC = Helpers::AdventOfCode.new(File.join(__dir__, 'input.txt'))
def solve(part)
  condition = part == 1 ? '00000' : '000000'
  secret_key = AOC.file.join('')
  digit = 0
  loop do
    character = Digest::MD5.hexdigest(secret_key + digit.to_s.rjust(6, "0"))
    break if character.start_with?(condition)

    digit += 1
  end

  digit
end

puts "[P1] #{solve(1)}"
puts "[P2] #{solve(2)}"
