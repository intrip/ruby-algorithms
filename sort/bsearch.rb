# O(lgn)
def bsearch(arr, val, start=0, to=nil)
  if to.nil?
    to = arr.length - 1
  end

  if start > to
    return nil
  end

  mid = (start + to) / 2

  # search for pivot on the left
  if arr[mid] > val
    bsearch(arr, val, start, mid - 1)
  elsif arr[mid] < val
    bsearch(arr, val, mid + 1, to)
  else
    return mid
  end
end

