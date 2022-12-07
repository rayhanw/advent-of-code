require_relative "methods"

file = File.readlines("input.txt").map(&:strip)
$total_size = 0

unless Dir.exist?("home")
  puts "-- SETUP FOLDER --"
  system("rm -rf home")
  system("mkdir home")
  file.each do |line|
    if line[0] == "$"
      cmd = line.gsub("$ ", '')
      cmd_sep = cmd.split
      if cmd_sep[0] == 'cd'
        if cmd_sep[1] == '..'
          Dir.chdir('..')
        else
          dir = cmd_sep[1] == '/' ? 'home' : cmd_sep[1]
          Dir.chdir(dir)
        end
      end
    else
      cmd = line.split
      if cmd[0] == 'dir'
        system("mkdir #{cmd[1]}")
      else
        File.open(cmd[1], 'w') do |file|
          cmd[0].to_i.times do
            file.write('a')
          end
        end

        # File.open(cmd[1], 'w') { |f| f.write(cmd[0]) }
      end
    end
  end

  puts "-- DONE SETUP FOLDER --\n\n"
end

def get_size(directory = File.join(__dir__, 'home/*'))
  directory_size = 0
  sub_directory_size = 0
  Dir[directory].each do |f|
    if File.file?(f)
      directory_size += File.size(f)
    else
      s = get_size("#{f}/*")
      sub_directory_size += s
    end

    size = directory_size + sub_directory_size
    if size < 100_000
      p f
      p "size: #{size}"
      $total_size += size
    end
  end

  return directory_size + sub_directory_size
end

get_size

p $total_size

# def recursive_fs(file_system, dir = File.join(__dir__, 'home/*'))
#   Dir[dir].sort.each do |ele|
#     if File.file?(ele)
#       key = ele.gsub("/Users/rawirjowerdojo/code/rayhanw/advent-of-code/2022/07/", "")
#       if File.file?(ele)
#         dig_set(file_system, key.split("/"), File.readlines(ele).map(&:chomp)[0].to_i)
#       else
#         dig_set(file_system, key.split("/"), {})
#       end
#       # dig_set(file_system, )
#       # p "get size of #{key}"
#       # puts
#     else
#       folder = "#{ele}/*"
#       recursive_fs(file_system, folder)
#     end
#   end
# end

# recursive_fs(file_system)
# file_system["/"] = file_system["home"]
# file_system.delete("home")

# pp file_system
