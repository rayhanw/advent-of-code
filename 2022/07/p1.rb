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

puts "File system:"
pp file_system
puts
rest_dir = file_system.reject { |k, _| k == "/" }
puts "Other dirs:"
pp rest_dir
puts

# Go over the directories that needs to be put in
# rest_dir.each do |k, v|
#   if file_system["/"][k] == {}
#     file_system["/"][k] = v
#     file_system.delete(k)
#   end
# end

main_keys = file_system["/"].keys.reject { |k| k == "contents" }
puts "Main keys:"
p main_keys
puts
keys_to_remove = rest_dir.keys - main_keys
puts "keys to remove:"
p keys_to_remove

until main_keys.sort == rest_dir.keys.sort do
  break
end

puts
print "----------------------"
puts "\nModified file system:"
pp file_system
