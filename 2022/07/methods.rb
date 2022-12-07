class Hash
  def deep_traverse(&block)
    stack = map { |k,v| [ [k], v ] }
    while not stack.empty?
      key, value = stack.pop
      yield(key, value)
      if value.is_a? Hash
        value.each { |k, v| stack.push [key.dup << k, v] }
      end
    end
  end
end

def iterate(hash, others, file_system)
  h = hash.reject { |k| k == "contents" }
  h.each do |k, v|
    if v.is_a?(Hash)
      if others.keys.include?(k)
        hash[k] = others[k]
        file_system.delete(k)
      end
      iterate(v, others, file_system)
    else
      puts "key: #{k}\n => #{v}"
    end
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

def dig_set(obj, keys, value)
  key = keys.first
  if keys.length == 1
    obj[key] = value
  else
    obj[key] = {} unless obj[key]
    dig_set(obj[key], keys.slice(1..-1), value)
  end
end

def hiterate(h, path = nil)
  h.deep_traverse do |path, value|
    # If v is nil, an array is being iterated and the value is k.
    # If v is not nil, a hash is being iterated and the value is v.
    #

    if value.is_a?(Hash)
      hiterate(value, path)
    elsif value.is_a?(Array)
      val = value.map(&:values).flatten.map(&:to_i).sum
      dig_set(h, path, val)
    end
  end

  h
end

def iterate_l(obj, h)
  h.each do |k, v|
    # If v is nil, an array is being iterated and the value is k.
    # If v is not nil, a hash is being iterated and the value is v.
    #
    value = v || k

    if value.is_a?(Hash)
      puts "evaluating: #{value} recursively..."
      p value.to_a
      iterate_l(obj, value)
    else
      # MODIFY HERE! Look for what you want to find in the hash here
      # if v is nil, just display the array value
      puts v ? "key: #{k} value: #{v}" : "array value #{k}"
    end
    puts
  end
end

def deep_to_a(hash)
  hash.map do |v|
    if v.is_a?(Hash) or v.is_a?(Array) then
      deep_to_a(v)
    else
      v
    end
  end
end
