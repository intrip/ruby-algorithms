=begin
arr[] = 64 25 12 22 11

// Find the minimum element in arr[0...4] and place it at beginning
11 25 12 22 64

// Find the minimum element in arr[1...4] and 
// place it at beginning of arr[1...4]
11 12 25 22 64

// Find the minimum element in arr[2...4] and 
// place it at beginning of arr[2...4]
11 12 22 25 64

// Find the minimum element in arr[3...4] and 
// place it at beginning of arr[3...4]
11 12 22 25 64 
=end

def selection_sort(arr)
  len = arr.length() -1
  for i in 0..(len-1)
    for j in (i+1)..len
      min = i
      # if the j item is smaller then current min
      if arr[j] < arr[min]
        min = j
      end
      arr[i],arr[min]=arr[min],arr[i]
    end
  end
  arr
end

arr = [3, 4, 5, 1, 2]
times = 10 ** 6
require 'benchmark'
Benchmark.bm do |x|
  x.report("selection_sort: ") { for i in 1..times; selection_sort(arr.clone) end;}
end
puts "arr #{arr}"
puts "Selection sort: #{selection_sort(arr)}"

=begin
Time Complexity: O(n*n) as there are two nested loops.
Auxiliary Space: O(1)
The good thing about selection sort is it never makes more than O(n) swaps and can be useful when memory write is a costly operation.
=end
