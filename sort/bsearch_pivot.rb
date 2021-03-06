require_relative 'bsearch.rb'

# Search an element in a sorted and rotated array
# An element in a sorted array can be found in O(log n) time via binary search.
# But suppose we rotate an ascending order sorted array at some pivot unknown to you beforehand.
# So for instance, 1 2 3 4 5 might become 3 4 5 1 2.
# Define a way to find an element in the rotated array in O(log n) time.

# pivot on middle
arr = [3, 4, 5, 1, 2]

# pivot on left [4,5,1,2,3]

# pivot on right [2,3,4,5,1]

# Searches for the pivot element in the given arr
# o(lgn)
def find_pivot(arr, start=0, to=nil)
  if to.nil?
    to = arr.size() -1
  end

  if start >= to
    return nil
  end

  mid = (start+to) / 2

  #i am the pivot
  if arr[mid] > arr[mid+1]
    return mid
  end

  #mid-1 is the pivot
  if arr[mid] < arr[mid-1]
    return mid-1;
  end

  # if the first element is bigger then mid the pivot is in the left side
  if arr[start] > arr[mid]
    find_pivot(arr,start,mid-1)
  else
    find_pivot(arr,mid+1,to)
  end
end

# O(lgn)
def bsearch_pivot(arr, val)

  # 1. find the pivot
  pivot = find_pivot(arr)

  # 2. split the list in 2 list
  arr_a = arr[0..pivot]
  arr_b = arr[(pivot+1)..(arr.size-1)]

  # 3. find the elemen in the 2 lists
  res_a = bsearch(arr_a,val)
  res_b = bsearch(arr_b,val)

  # build the original index
  res_a ? res_a : (res_b + arr_a.size)
end

def bsearch_pivot_opt(nums, target)
  low = 0
  high = nums.length - 1

  while low <= high
    mid = (low + high) / 2
    return mid if nums[mid] == target

    # left side is sorted
    if nums[low] <= nums[mid]
      if nums[low] <= target && target <= nums[mid]
        high = mid - 1
      else
        low = mid + 1
      end
    else
      # right side is sorted
      if nums[mid] <= target && target <= nums[high]
        low = mid + 1
      else
        high = mid - 1
      end
    end
  end

  -1
end

require 'benchmark'
Benchmark.bm do |x|
  x.report("bsearch_pivot: ") { for i in 1..1000000; bsearch_pivot(arr,2) end;}
  x.report("bsearch_pivot_opt: ") { for i in 1..1000000; bsearch_pivot_opt(arr,2) end;}
end
