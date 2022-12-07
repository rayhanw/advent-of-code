require_relative "methods"

file = File.readlines("input.txt").map(&:strip)
file_system = { "/" => { "contents" => [] } }
groups = file.slice_before { |ele| ele.match?(/cd/) }.to_a
make_file_system(file_system, groups)
rest_dir = file_system.reject { |k, _| k == "/" }
iterate(file_system, rest_dir, file_system)

puts "Creating Folder"
print "----------------------\n"
puts "Done Folder"
puts
puts "result:"

res = hiterate(file_system)
obj = {}
# iterate_l(obj, res)

p deep_to_a(res)
