# Let A[1..n] be an array of distinct numbers. If i < j and A[i] > A[j], then
# the pair (i,j) is called an inversion of A.
#
# The method below finds all the inversion of arr in nlog(n) time.
# NOTE: this is not tail recursive, we could make it tail recursive by passing an extra param that handles the count
def count_inversions(arr, l, r)
  inversions = 0

  if l < r
    mid = (r + l) / 2
    inversions += count_inversions(arr, l, mid)
    inversions += count_inversions(arr, mid + 1, r)
    inversions += merge_and_count_inversions(arr, l, mid, r)
    inversions
  else
    0
  end
end

def merge_and_count_inversions(arr, l, mid, r)
  count = 0
  left = arr[l..mid]
  right = arr[(mid+1)..r]

  i = 0
  j = 0
  for k in l..r do
    if i >= left.length
      arr[k] = right[j]
      j += 1
    elsif j >= right.length
      arr[k] = left[i]
      i += 1
    elsif left[i] <= right[j]
      arr[k] = left[i]
      i += 1
    else
      arr[k] = right[j]
      # we count the swap that we do to the left: for every swap we have 1 inversion
      count += left.length - i
      j += 1
    end
  end

  count
end

arr = [2,3,8,6,1,2]
puts "Inversions on #{arr.inspect}: #{count_inversions(arr, 0, arr.length - 1)}. The array is also sorted due to merge sort: #{arr.inspect}"
