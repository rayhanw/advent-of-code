file = File.readlines('day_10.txt').map(&:strip)

ILLEGAL_CHARACTERS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}
OPPOSITES = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
SCORE_MAPS = %w[) \] } >].map.with_index { |char, i| [char, i + 1] }.to_h

def part_one(file)
  characters = []

  file.each do |line|
    x = line.dup

    while x.length > 1
      len = x.length
      x.gsub!('()', '')
      x.gsub!('{}', '')
      x.gsub!('<>', '')
      x.gsub!('[]', '')

      break if len == x.length
    end

    if x.chars.any? { |char| ILLEGAL_CHARACTERS.keys.include?(char) }
      characters << x.chars.find { |char| ILLEGAL_CHARACTERS.keys.include?(char) }
    end
  end

  nums = characters.group_by { |char| char }.map do |k, v|
    ILLEGAL_CHARACTERS[k] * v.length
  end

  p nums.sum
end

# part_one(file)

def part_two(file)
  characters = []
  incompletes = []

  file.each do |line|
    x = line.dup

    while x.length > 1
      len = x.length
      x.gsub!('()', '')
      x.gsub!('{}', '')
      x.gsub!('<>', '')
      x.gsub!('[]', '')

      break if len == x.length
    end

    characters << line unless x.chars.any? { |char| ILLEGAL_CHARACTERS.keys.include?(char) }
  end

  characters.each do |line|
    x = line.dup

    while x.length > 1
      len = x.length
      x.gsub!('()', '')
      x.gsub!('{}', '')
      x.gsub!('<>', '')
      x.gsub!('[]', '')

      break if len == x.length
    end

    incompletes << x
  end

  fixes = []

  incompletes.each do |line|
    fix = []
    line.reverse.chars.each do |char|
      fix << OPPOSITES[char]
    end

    fixes << fix
  end

  score = []

  fixes.each do |fix|
    line_score = 0

    fix.each do |char|
      line_score *= 5
      line_score += SCORE_MAPS[char]
    end

    score << line_score
  end

  score.sort!
  p score[(score.length / 2)]
end

part_two(file)
