require 'byebug'

MAX_STEP = 6

def solution(a)
  res=0
  i=0

  first_neg_idx = nil
  neg_c = 0

  while i < a.length
    if a[i] >= 0
      if first_neg_idx
        # we encountered neg numbers, need to update res calculaing max_neg_steps
        first_neg_idx, neg_c, end_idx, i, res = max_neg_steps(a, first_neg_idx, neg_c, res)
      else
        res += a[i]
      end
    else
      first_neg_idx ||= i

      if i == a.length - 1
        # reached the end of the array: calculate the ending result
        first_neg_idx, neg_c, end_idx, i, res = max_neg_steps(a, first_neg_idx, neg_c, res)
      end

      neg_c += 1
    end

    i += 1
  end

  res
end

def max_neg_steps(a, first_neg_idx, neg_c, res)
  end_idx = first_neg_idx + neg_c
  i = end_idx
  res = max_sub(a, first_neg_idx - 1, end_idx, res)
  # reset
  first_neg_idx = nil
  neg_c = 0

  [first_neg_idx, neg_c, end_idx, i, res]
end

def max_sub(a, start_i, end_idx, max)
  paths = [[start_i, max]]
  all_steps = steps(a, paths, end_idx)
  all_steps.map(&:last).max
end

def steps(a, paths, end_idx)
  new_path = []
  done = true

  paths.each do |path|
    start = path[0]
    tmax = path[1]

    # TODO just set max = max(max, tmax) and skip this instead
    # we already completed the computation of this path
    if end_idx == start
      new_path << path
    elsif (end_idx - start) <= MAX_STEP
      # can finish with 1 step
      new_path << [end_idx, (tmax + a[end_idx])]
    else
      # need to calculate all the steps recursively
      done = false
      (1..MAX_STEP).each do |i|
        next_i = start + i
        new_path << [next_i, (tmax + a[next_i])]
      end
    end
  end

  done ? new_path : steps(a, new_path, end_idx)
end

arr = [1,-2, 0, 9, -1, -2]
# should be 8
p solution(arr)

arr = [1,-2, 0, 9, -1, -3, -5, -1, -1, -2, -4, -1, -1 -1, -2]
# should be 7
p solution(arr)

