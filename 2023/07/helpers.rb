def merge_sort(array)
  if array.length <= 1
    array
  else
    mid = (array.length / 2).floor
    left = merge_sort(array[0..mid-1])
    right = merge_sort(array[mid..array.length])
    merge(left, right)
  end
end

def merge(left, right)
  if left.empty?
    right
  elsif right.empty?
    left
  elsif left[0] < right[0]
    [left[0]] + merge(left[1..left.length], right)
  else
    [right[0]] + merge(left, right[1..right.length])
  end
end

def heap_sort(array)
  n = array.length
  a = [nil] + array

  (n / 2).downto(1) do |i|
    heapify(a, i, n)
  end

  while n > 1
    a[1], a[n] = a[n], a[1]
    n -= 1
    heapify(a, 1, n)
  end
  a.drop(1)
end

def heapify(array, parent, limit)
  root = array[parent]
  while (child = 2 * parent) <= limit
    child += 1 if child < limit && array[child] < array[child + 1]
    break if root >= array[child]
    array[parent], parent = array[child], child
  end
  array[parent] = root
end

def bubble_sort(array)
  return array if array.size <= 1

  swap = true
    while swap
      swap = false
      (array.length - 1).times do |x|
        if array[x] > array[x+1]
          array[x], array[x+1] = array[x+1], array[x]
          swap = true
        end
      end
    end
  array
end

def count_initial_occurrences(line)
  first_char = line[0]
  count = 0
  line.chars.each do |char|
    break if char != first_char

    count += 1
  end
  count
end
