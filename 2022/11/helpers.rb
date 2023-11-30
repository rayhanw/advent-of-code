def calculator(x, operation, y)
  case operation
  when '+'
    x + y
  when '-'
    x - y
  when '*'
    x * y
  when '/'
    x / y
  end
end

def print_situation(monkeys)
  monkeys.each do |monkey|
    puts """Monkey #{monkey[:no]}
    - Items: #{monkey[:items]}
    - Operation: old #{monkey[:operation][:op]} #{monkey[:operation][:number]}
    - Test: divisible by #{monkey[:test]}
    \t If true: throw to monkey #{monkey[:test_y]}
    \t If false: throw to monkey #{monkey[:test_n]}
    """
  end
end

def run_loop(monkeys, max = 20, step = 1)
  count = 1
  while count <= max
    monkeys.each do |monkey|
      puts "Monkey #{monkey[:no]}:"
      monkey[:items].each do |item|
        monkey[:inspect_count] += 1
        puts "\tMonkey inspects an item with a worry level of #{item}"

        y = monkey[:operation][:number].to_i
        y = item if y.zero?
        worry_level = calculator(item, monkey[:operation][:op], y)
        puts "\t\tWorry level is #{monkey[:operation][:op]} #{monkey[:operation][:number]} = #{worry_level}"

        worry_level /= 3 if step == 1
        puts "\t\tMonkey gets bored with item. Worry level is #{'/ 3' if step == 1} to #{ColorizedString[worry_level.to_s].colorize(background: :red).underline}."

        divisible = (worry_level % monkey[:test]).zero?
        puts "\t\tCurrent worry level is #{divisible ? 'divisible' : 'not divisible'} by #{monkey[:test]}"

        monkey[:items] = []
        thrown_monkey_no = divisible ? monkey[:test_y] : monkey[:test_n]
        puts "\t\tItem with worry level #{worry_level} is thrown to #{ColorizedString["monkey #{thrown_monkey_no}"].colorize(color: :black, background: :cyan).underline}"

        thrown_monkey = monkeys.find { |m| m[:no] == thrown_monkey_no }
        thrown_monkey[:items] << worry_level
      end
    end
    count += 1
  end
end
