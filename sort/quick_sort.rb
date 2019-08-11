=begin
Quick sort
Like Merge Sort, QuickSort is a Divide and Conquer algorithm. It picks an element as pivot and partitions the given
array around the picked pivot. There are many different versions of quickSort that pick pivot in different ways.
Always pick first element as pivot.
Always pick last element as pivot (implemented below)
Pick a random element as pivot.
Pick median as pivot.
The key process in quickSort is partition(). Target of partitions is, given an array and an element x of
array as pivot, put x at its correct position in sorted array and put all smaller elements (smaller than x) before x,
 and put all greater elements (greater than x) after x. All this should be done in linear time.
=end

def partition(arr,start,to)
  pivot = arr[to]
  # lower part
  li = start

  for ui in li..(to-1)
    if arr[ui] <= pivot
      arr[li],arr[ui]=arr[ui],arr[li]
      li+=1
    end
  end

  # move the pivot in middle
  arr[li],arr[to]=arr[to],arr[li]
  li
end

def quick_sort(arr,start=0, to=nil)
  to = arr.length() -1 if to.nil?

  return if start >= to

  partition_index = partition(arr,start,to)
  # we exclude the pi_item because is already sorted: the pivot
  quick_sort(arr,start,partition_index-1)
  quick_sort(arr,partition_index+1,to)
  arr
end

arr = [3, 4, 5, 1, 2]

times = 10 ** 6
require 'benchmark'
Benchmark.bm do |x|
  x.report("quick_sort: ") { for i in 1..times; quick_sort(arr.clone) end;}
end

puts "arr #{arr}"
puts "Quick sort: #{quick_sort(arr.clone)}"
