require_relative "answers"

# total = GROUPS.map do |group|
#   answers = group.split("").uniq
#   answers.length
# end.sum

# p total

answer = 0

SECOND_GROUP.each do |group|
  g_hash = Hash.new(0)
  group.each do |g_string|
    g_string.chars.each do |letter|
      g_hash[letter] += 1
    end
  end


  g_hash.each do |k, v|
    answer += 1 if v == group.length
  end
end

p answer
