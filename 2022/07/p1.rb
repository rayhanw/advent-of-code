file = File.readlines("input.txt").map(&:strip)
file_system = { "/" => { "contents" => [] } }
groups = file.slice_before { |ele| ele.match?(/cd/) }.to_a

def nested_hash_value(obj, key)
  if obj.respond_to?(:key?) && obj.key?(key)
    obj[key]
  elsif obj.respond_to?(:each)
    r = nil
    obj.find { |*a| r = nested_hash_value(a.last, key) }
    r
  end
end

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

main_dir = file_system["/"]
pp main_dir
puts

# until file_system.keys.length == 1
  # Grabs main directory
  main_dir = file_system["/"]
  # Grabs ever other directories that should be found somewhere within and replaced with
  rest_dir = file_system.reject { |k, _| k == "/" }
  rest_dir.each do |k, v|
    p k
    p v.reject { |k2, _| k2 == "contents" }
    puts
  end
# end
