file = File.readlines("input.txt").map(&:strip)
COMMAND_PREFIX = "$"
file_system = { "/" => { "contents" => [] } }
groups = file.slice_before { |ele| ele.match?(/cd/) }.to_a

groups[0..0].each do |dir|
  directory = dir[0].gsub("$ cd ", '')
  contents = dir[1..].reject { |txt| txt[0] == "$" }
  contents.each do |content|
    structure = content.split(" ")
    if structure[0] == "dir"
      file_system[directory][structure[1]] = {}
    else
      size = structure[0]
      name = structure[1]
      file_system[directory]["contents"] << { "name" => name, size => size }
    end
  end
end

# groups[1..1].each do |dir|
#   directory = dir[0].gsub("$ cd ", '')
#   contents = dir[1..].reject { |txt| txt[0] == "$" }
#   puts "dir: #{directory}"
# end

pp file_system
