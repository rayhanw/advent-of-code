require "benchmark"
require "colorize"
require "colorized_string"

FILE = File.readlines("input.txt").map(&:strip)

def can_be_made_with_regex?(design, regex_pattern)
  regex_pattern.match?(design)
end

CHARACTER_MAP = Hash.new { |h, k| h[k] = [] }

def count_possible_ways(design, patterns)
  possibles = Array.new(design.size + 1, 0)
  possibles[0] = 1

  puts "Design: #{design}".colorize(:blue)
  # We skip 0 because we already set it to 1 and doing substring -1 to n will be empty
  (1..design.size).each do |i|
    puts " i: #{i}".colorize(:green)
    patterns.each do |pattern|
      next if (i - pattern.size).negative?

      substring = design[(i - pattern.size)...i]
      possible = substring == pattern
      next unless possible && possibles[i - pattern.size].positive?

      puts "  Substring: #{substring.colorize(:green)}"
      puts "  Range: [#{(i - pattern.size)...i}]".colorize(:light_blue)
      puts "  Checking against pattern #{pattern.colorize(:yellow)} |#{possible ? '🟢' : '🔴'}|"
      puts "   possibles[#{i}] += possibles[#{i - pattern.size}] (value: #{possibles[i - pattern.size]})".colorize(:green)
      possibles[i] += possibles[i - pattern.size]
    end

    puts "Current possibles: #{possibles}"
  end

  puts "#{design} -> #{possibles[design.size]}".colorize(:red)

  possibles[design.size]
end

time = Benchmark.realtime do
  patterns, _, *designs = FILE

  patterns = patterns.split(", ")
  puts "Available patterns: [#{patterns.join(', ')}]".colorize(:yellow)
  puts

  ### P1
  regex_pattern = /^(#{patterns.join('|')})+$/

  possible_designs = designs.sum do |design|
    is_possible = can_be_made_with_regex?(design, regex_pattern)
    puts "#{design} #{is_possible ? '🟢' : '🔴'}"
    is_possible ? 1 : 0
  end

  puts
  puts "[P1]: Possible designs: #{possible_designs}".colorize(:green)
  puts
  puts
  ###

  ### P2
  answer = designs.sum do |design|
    count_possible_ways(design, patterns)
  end

  puts "[P2]: Possible designs: #{answer}".colorize(:green)
  ###
end

puts
puts "Time: #{time.round(2)}".colorize(:magenta)
