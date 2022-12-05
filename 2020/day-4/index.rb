require_relative "passport"

MANDATORY_KEYS = %i[ecl pid eyr hcl byr iyr hgt]
EYE_COLORS = %w[amb blu brn gry grn hzl oth]

answer = 0
answer_two = 0
PASSPORTS.each do |passport|
  answer += 1 if MANDATORY_KEYS.all? { |key| passport.keys.include?(key) }
end

def inches_to_boolean(height)
  return false if height.nil? || !height.match?(/(cm|in)/)

  if height.include? "cm"
    number = height.match(/\d+/)[0].to_i
    return number >= 150 && number <= 193
  end

  if height.include? "in"
    height.gsub!("in", "")
  end

  number = height.match(/\d+/)[0].to_i * 2.54

  number >= 150 && number <= 193
end

def valid_hcl(hcl)
  hcl.match?(/([0-9]|[a-f]){6}/)
end

PASSPORTS.each do |passport|
  byr = passport[:byr].to_i
  iyr = passport[:iyr].to_i
  eyr = passport[:eyr].to_i
  hcl = passport[:hcl]
  ecl = passport[:ecl]&.downcase
  pid = passport[:pid]
  # OK
  byr_status = byr.to_s.chars.length == 4 && byr >= 1920 && byr <= 2002
  # OK
  iyr_status = iyr.to_s.chars.length == 4 && iyr >= 2010 && iyr <= 2020
  eyr_status = eyr.to_s.chars.length == 4 && eyr >= 2020 && eyr <= 2030
  hgt_status = inches_to_boolean(passport[:hgt])
  hcl_status = hcl && hcl[0] == '#' && hcl.length == 7 && valid_hcl(hcl[1..6])
  ecl_status = ecl && EYE_COLORS.include?(ecl)
  pid_status = pid&.length == 9
  status = byr_status && iyr_status && eyr_status && hgt_status && hcl_status && ecl_status && pid_status

  answer_two += 1 if MANDATORY_KEYS.all? { |key| passport.keys.include?(key) } && status
end

p answer_two
