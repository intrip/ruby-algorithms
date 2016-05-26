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

	#higher part
	for ui in li..to
		if arr[ui] <= pivot
			arr[li],arr[ui]=arr[ui],arr[li]
			li+=1
		end
	end

	p "LI: ", li, "TO: ", to
	# move the pivot in middle
	arr[li+1],arr[to]=arr[to],arr[li+1]

	li+1
end


def quick_sort(arr,start=0, to=nil)
  to = arr.length() -1 if to.nil?

  return unless start < to

  partition_index = partition(arr,start,to)
  p partition_index, start, to; sleep 1 
  p arr
  # we exclude the pi_item because is already sorted: the pivot
  quick_sort(arr,start,partition_index-1)
  quick_sort(arr,partition_index+1,to)

end


# def quick_sort(arr,start=0, to=nil)
#   to = arr.length() -1 if to.nil?

#   return if start > to

#   # pickup the pivot el
#   pivot = arr[to] 

#   l=[]
#   r=[]

#   for i in start..(to-1)
#   	if arr[i] < pivot
#   		l << arr[i]
#   	else
#   		r << arr[i]
#   	end
#   end

#   quick_sort(l)
#   quick_sort(r)

#   l + [pivot] + r
# end

arr = [3, 4, 5, 1, 2]

times = 10 ** 6
require 'benchmark'
# Benchmark.bm do |x|
# 	x.report("quick_sort: ") { for i in 1..times; quick_sort(arr.clone) end;}
# end
puts "arr #{arr}"
puts "Quick sort: #{quick_sort(arr.clone)}"
