file = File.readlines("input.txt").map(&:strip)
file_system = { "/" => { "contents" => [] } }
groups = file.slice_before { |ele| ele.match?(/cd/) }.to_a

def make_file_system(file_system, groups)
  groups.each do |dir|
    directory = dir[0].gsub("$ cd ", '')
    contents = dir[1..].reject { |txt| txt[0] == "$" }
    contents.each do |content|
      structure = content.split(" ")
      file_system[directory] = { "contents" => [] } if file_system[directory].nil?
      if structure[0] == "dir"
        file_system[directory][structure[1]] = {}
      else
        size = structure[0]
        name = structure[1]
        file_system[directory]["contents"] << { name => size }
      end
    end
  end

  file_system
end

make_file_system(file_system, groups)

pp file_system
