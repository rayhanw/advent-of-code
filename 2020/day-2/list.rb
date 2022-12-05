list = File.read("list.txt").split("\n")

PASSWORD_POLICY = []

list.each do |line|
  policy = line.split
  policy[0] = policy[0].split("-").map(&:to_i)
  policy[1].gsub!(":", "")
  structure = {
    min: policy[0][0],
    max: policy[0][1],
    char: policy[1],
    word: policy[2]
  }
  PASSWORD_POLICY << structure
end
