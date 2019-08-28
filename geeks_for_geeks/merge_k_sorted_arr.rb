# Merge k sorted arrays | Set 1
# Given k sorted arrays of size n each, merge them and print the sorted output.
# Example:

# Input:
# k = 3, n =  4
# arr[][] = { {1, 3, 5, 7},
#             {2, 4, 6, 8},
#             {0, 9, 10, 11}} ;

# Output: 0 1 2 3 4 5 6 7 8 9 10 11

require_relative '../data_structures/heap/heap.rb'

# We can create a min heap for all the first k elements and keep calling extract_min.
# When we remove 1 element from the heap we add a new one of the same array of the element
# that was extracted. We repeat the procedure until we empty all the sub arrays.
# This should take kn*lg(k) time.
def solution(arr)
  sol = []

  mappings = {}
  heap_arr = []
  arr.each_with_index do |v,k|
    val = v.shift
    heap_arr.push(val)
    mappings[val] = k
  end # O(k)

  mh = MinHeap.build(heap_arr)  # O(k*lg(k))
  until mh.empty? do # we do this nk times so the loop takes O(nk lg(k))
                     # which is the runtime of ths method
    el = mh.extract_min  # O(lg(k))
    el_index = mappings[el]
    sol.push(el)

    new_el = arr[el_index].shift
    mappings[new_el] = el_index
    mh.insert(new_el) if new_el # O(lg(k))
  end

  sol
end

arr = [[1, 3, 5, 7],
  [2, 4, 6, 8],
  [0, 9, 10, 11]]

p solution(arr)
# Output: 0 1 2 3 4 5 6 7 8 9 10 11
