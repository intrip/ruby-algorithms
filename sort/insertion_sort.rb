=begin
Algorithm
// Sort an arr[] of size n
insertionSort(arr, n)
Loop from i = 1 to n-1.
……a) Pick element arr[i] and insert it into sorted sequence arr[0…i-1]
Example: 
12, 11, 13, 5, 6
Let us loop for i = 1 (second element of the array) to 5 (Size of input array)
i = 1. Since 11 is smaller than 12, move 12 and insert 11 before 12
11, 12, 13, 5, 6
i = 2. 13 will remain at its position as all elements in A[0..I-1] are smaller than 13
11, 12, 13, 5, 6
i = 3. 5 will move to the beginning and all other elements from 11 to 13 will move one position ahead of their current position.
5, 11, 12, 13, 6
i = 4. 6 will move to position after 5, and elements from 11 to 13 will move one position ahead of their current position.
5, 6, 11, 12, 13
=end

def insertion_sort(arr)
	n = arr.length() -1
	for i in 1..n
		pivot = arr[i]
		j = i - 1

		# move every item ahead if is bigger then the pivot
		# we go backward because the biggest is on the right
		while(j>=0 && arr[j] > pivot)
			arr[j+1]=arr[j]
			j-=1
		end
		# then valorize the pivot
		arr[j+1] = pivot
	end

	arr
end

# returns where the new pivot should be insert
def bsearch_ins_pivot(arr,pivot,from=0,to=nil)
	to = arr.length() -1 if to.nil?
	
	if to <= from
		# if the from is bigger than the pivot need to be insert in his position, otherwise the position after
		return (arr[from] > pivot) ? from : from+1
	end

	mid = (to+from) / 2

	if(arr[mid] == pivot)
		return mid+1;
	end

	if(pivot < arr[mid])
		return bsearch_ins_pivot(arr,pivot,from,mid-1)
	end
	bsearch_ins_pivot(arr,pivot,mid+1,to)
end

def insertion_sort_pivot(arr)
	n = arr.length() -1
	for i in 1..n
		pivot = arr[i]
		j = i-1

		pos = bsearch_ins_pivot(arr,pivot,0,j)
		while(j>=pos)
			arr[j+1]=arr[j]
			j-=1
		end
		arr[j+1]= pivot
	end
	arr
end

arr = [3, 4, 5, 1, 2]

require 'benchmark'
# Benchmark.bm do |x|
	# x.report("insertion_sort: ") { for i in 1..1000000; insertion_sort(arr.clone) end;}
# end
puts "arr #{arr}"
puts "Insertion sort: #{insertion_sort(arr.clone)}"
puts "Insertion sort: #{insertion_sort_pivot(arr.clone)}"