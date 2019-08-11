=begin
Merge Sort
MergeSort is a Divide and Conquer algorithm. It divides input array in two halves, calls itself for the two halves and then merges the two sorted halves. The merg() function is used for merging two halves. The merge(arr, l, m, r) is key process that assumes that arr[l..m] and arr[m+1..r] are sorted and merges the two sorted sub-arrays into one. See following C implementation for details.
MergeSort(arr[], l,  r)
If r > l
     1. Find the middle point to divide the array into two halves:
             middle m = (l+r)/2
     2. Call mergeSort for first half:
             Call mergeSort(arr, l, m)
     3. Call mergeSort for second half:
             Call mergeSort(arr, m+1, r)
     4. Merge the two halves sorted in step 2 and 3:
             Call merge(arr, l, m, r)
The following diagram from wikipedia shows the complete merge sort process for an example array {38, 27, 43, 3, 9, 82, 10}. If we take a closer look at the diagram, we can see that the array is recursively divided in two halves till the size becomes 1. Once the size becomes 1, the merge processes comes into action and starts merging arrays back till the complete array is merged.
=end

# Merges two subarrays of arr[].
# First subarray is arr[l..m]
# Second subarray is arr[m+1..r]
def merge(arr, start, mid, to)
  l = arr[start..mid]
  r = arr[(mid+1)..to]

  nl = l.length
  nr = r.length

  j = i = 0
  # first index of the sub array
  k = start
  # we position the first item in left or right
  while j < nl && i < nr
    if l[j] <= r[i]
      arr[k] = l[j]
      j+=1
    else
      arr[k] = r[i]
      i+=1
    end
    k+=1
  end

  # position the remaining left items if the left and right array doesn't have the same size
  while j < nl
    arr[k] = l[j]
    j+=1
    k+=1
  end
  while i < nr
    arr[k] = r[i]
    i+=1
    k+=1
  end

  arr
end

def merge_sort(arr, start=0, to=nil)
  to = arr.length() -1 if to.nil?

  return if start >= to

  mid = (start+to)/2

  merge_sort(arr,start,mid)
  merge_sort(arr,mid+1,to)
  merge(arr,start,mid,to)
end


arr = [3, 4, 5, 1, 2]
p "arr: #{arr}"
p "Merge sort: #{merge_sort arr.clone}"
