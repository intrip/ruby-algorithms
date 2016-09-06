# A recursive implementation of insertion_sort
# In order to sort a[0..n] we recursively sort a[0..n-1] and insert n into the sorted array a[0..n-1]

def insertion_sort_recursive(arr, n=1)
	len = arr.length

	return arr if n==len

	# arr 0..n-1 is sorted so now w insert a[n] in the right position
	insert_item(arr, arr[n], n-1)
	# recursively call insertion_sort
	insertion_sort_recursive(arr,n+1)
end

# Insert the item n in the sorted array arr[0..n-1]
def insert_item(arr, pivot, to)
	# if to<0 and we still didn't found any item smaller than the pivot than
	# the pivot needs to be positioned at the start
	if to<0
		arr[0] = pivot
		return
	end

	# DEUBUG
	# p pivot, arr[to], to, arr
	# puts ">>>"
	if pivot < arr[to]
		arr[to+1] = arr[to]
		insert_item(arr,pivot,to-1)
	else
		# we found the position for the pivot
		arr[to+1]=pivot
	end
end

arr = [3, 4, 5, 1, 2]

puts "Insertion sort recursive: #{insertion_sort_recursive(arr)}"
