=begin
Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in wrong order.
Example:
First Pass:
( 5 1 4 2 8 ) –> ( 1 5 4 2 8 ), Here, algorithm compares the first two elements, and swaps since 5 > 1.
( 1 5 4 2 8 ) –>  ( 1 4 5 2 8 ), Swap since 5 > 4
( 1 4 5 2 8 ) –>  ( 1 4 2 5 8 ), Swap since 5 > 2
( 1 4 2 5 8 ) –> ( 1 4 2 5 8 ), Now, since these elements are already in order (8 > 5), algorithm does not swap them.
Second Pass:
( 1 4 2 5 8 ) –> ( 1 4 2 5 8 )
( 1 4 2 5 8 ) –> ( 1 2 4 5 8 ), Swap since 4 > 2
( 1 2 4 5 8 ) –> ( 1 2 4 5 8 )
( 1 2 4 5 8 ) –>  ( 1 2 4 5 8 )
Now, the array is already sorted, but our algorithm does not know if it is completed. The algorithm needs one whole pass without any swap to know it is sorted.
Third Pass:
( 1 2 4 5 8 ) –> ( 1 2 4 5 8 )
( 1 2 4 5 8 ) –> ( 1 2 4 5 8 )
( 1 2 4 5 8 ) –> ( 1 2 4 5 8 )
( 1 2 4 5 8 ) –> ( 1 2 4 5 8 )
Following are implementations of Bubble Sort.
=end

def bubble_sort(arr)
	i=0
	while i < arr.length() -1
		j=0
		# i element are already in order!
		while j < arr.length() -1 -i
			if arr[j] > arr[j+1]
				# swap elements
				arr[j],arr[j+1] = arr[j+1],arr[j]
			end
			j+=1
		end
		i+=1
	end
	arr
end

=begin
Optimized Implementation:
The above function always runs O(n^2) time even if the array is sorted. It can be optimized by stopping the algorithm if inner loop didn’t cause any swap.
=end
def bubble_sort_opt(arr)
	i=0
	while i < arr.length() -1
		j=0
		has_swapped=false
		# i element are already in order!
		while j < arr.length() -1 -i
			if arr[j] > arr[j+1]
				# swap elements
				arr[j],arr[j+1] = arr[j+1],arr[j]
				has_swapped=true
			end
			j+=1
		end
		return arr unless has_swapped
		i+=1
	end
	arr
end

arr = [3, 4, 5, 1, 2]
times = 10 ** 6

require 'benchmark'
Benchmark.bm do |x|
	 x.report("bubble sort: ") { for i in 1..times; bubble_sort(arr.clone); end}
	 x.report("bubble sort_opt:") { for i in 1..times; bubble_sort_opt(arr.clone); end}
end
puts "Original array: #{arr.inspect}"
puts "Sorted array with bubble_sort: #{bubble_sort arr}"
puts "Sorted array with bubble_sort_opt: #{bubble_sort_opt arr}"

=begin
Worst and Average Case Time Complexity: O(n*n). Worst case occurs when array is reverse sorted.
Best Case Time Complexity: O(n). Best case occurs when array is already sorted.
Auxiliary Space: O(1)
Boundary Cases: Bubble sort takes minimum time (Order of n) when elements are already sorted.
Sorting In Place: Yes
Stable: Yes
Due to its simplicity, bubble sort is often used to introduce the concept of a sorting algorithm.
In computer graphics it is popular for its capability to detect a very small error (like swap of just two elements)
in almost-sorted arrays and fix it with just linear complexity (2n). For example, it is used in a polygon filling algorithm,
where bounding lines are sorted by their x coordinate at a specific scan line (a line parallel to x axis) 
and with incrementing y their order changes (two elements are swapped) only at intersections of two lines (Source: Wikipedia)
=end