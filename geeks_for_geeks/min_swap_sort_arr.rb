# Given an array of n distinct elements, find the minimum number of swaps required to sort the array.

# Examples:

# Input : [4, 3, 2, 1]
# Output : 2
# Explanation : Swap index 0 with 3 and 1 with 2 to
#               form the sorted array [1, 2, 3, 4].

# Input : [1, 5, 4, 3, 2]
# Output : 2

require 'byebug'
def min_swap(arr)
  p arr

  # Sequence: [7, 1, 3, 2, 4, 5, 6]
  # Enumerate it: [(0, 7), (1, 1), (2, 3), (3, 2), (4, 4), (5, 5), (6, 6)]
  # Sort the enumeration by value: [(1, 1), (3, 2), (2, 3), (4, 4), (5, 5), (6, 6), (0, 7)]
  sorted_count = arr.map.with_index do |v,i|
    [v,i]
  end.sort do |a,b|
    a[0] <=> b[0]
  end
  # Then semantically you sort the elements and then figure out how to put them to the initial state
  # via swapping through the leftmost item that is out of place.
  i = 0
  swaps = 0
  while i < sorted_count.length
    if sorted_count[i][1] != i
      swap(sorted_count, sorted_count[i][1], i)
      swaps += 1
    else
      i += 1
    end
  end

  swaps
end

def swap(arr, i, j)
  arr[i], arr[j] = arr[j], arr[i]
end
# should be 3
p min_swap([4, 5, 2, 1, 5])
