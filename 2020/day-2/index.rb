require_relative "list"

answer = []
answer_two = []

PASSWORD_POLICY.each do |policy|
  amount = policy[:word].count(policy[:char])
  answer << (amount >= policy[:min] && amount <= policy[:max])
end

# p answer.count(true)

PASSWORD_POLICY.each do |policy|
  word = policy[:word]
  char = policy[:char]
  min = policy[:min] - 1
  max = policy[:max] - 1

  if word[min] == char && word[max] == char
    structure = false
  elsif word[min] == char && word[max] != char
    structure = true
  elsif word[min] != char && word[max] == char
    structure = true
  else
    structure = false
  end

  answer_two << structure
end

p answer_two.count(true)
