# file = File.readlines("day_16.txt").map(&:strip)[0].hex.to_s(2)
file = File.readlines("day_16.txt").map(&:strip)[0]
mapping_file = File.readlines("day_16_mapping.txt").map(&:strip)
MAPPINGS = mapping_file.map do |line|
  split = line.split(" = ")
  [split[1], split[0]]
end.to_h


def set_length_4(str)
  str.rjust(4, "0")
end

# first_6 = file[0][0..5].chars.each_slice(3).to_a.map(&:join).map { |str| MAPPINGS[set_length_4(str)] }
# version = first_6[0]
# type_id = first_6[1]
# next_15 = file[0][6..20].chars.each_slice(5).to_a.map(&:join).map { |str| str[1..-1] }.join("")

header = file[0..5].chars.each_slice(3).to_a.map(&:join)
version = MAPPINGS[set_length_4(header[0])] # VERSION 4
type_id = MAPPINGS[set_length_4(header[1])] # TYPE_ID 4 -> LITERAL VALUE

p [version, type_id]

if type_id == '4'
  p 'LITERAL'
  bits = file[6..-4]
  p bits.chars.each_slice(5).to_a.map(&:join).map { |bit| bit[1..-1] }.join.to_i(2)
else
  p 'OPERATOR'
  length_type_id = file[6]
  if length_type_id == '0'
    p '15 BIT GROUPING'
    bit_group = file[7..-1]
    sub_packet_length = bit_group.chars.first(15).join.to_i(2)
    # p sub_packet_length # 27
    p bit_group[15..-1].chars.first(27).join
  end
end
