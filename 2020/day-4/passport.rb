file = File.read("passport.txt").split("\n\n")
PASSPORTS = []

file.each do |passport|
  passport.gsub!("\n", " ")
  passport = passport.split(" ")
  passport.map! { |pass| pass.split(":") }
  structure = {}
  passport.each do |key, value|
    structure[key] = value
  end

  PASSPORTS << structure
end

PASSPORTS.map! { |passport| passport.transform_keys!(&:to_sym) }
