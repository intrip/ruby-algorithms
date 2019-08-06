# https://app.codility.com/programmers/lessons/17-dynamic_programming/number_solitaire/
# A game for one player is played on a board consisting of N consecutive squares, numbered from 0 to N − 1. There is a number written on each square. A non-empty array A of N integers contains the numbers written on the squares. Moreover, some squares can be marked during the game.

# At the beginning of the game, there is a pebble on square number 0 and this is the only square on the board which is marked. The goal of the game is to move the pebble to square number N − 1.

# During each turn we throw a six-sided die, with numbers from 1 to 6 on its faces, and consider the number K, which shows on the upper face after the die comes to rest. Then we move the pebble standing on square number I to square number I + K, providing that square number I + K exists. If square number I + K does not exist, we throw the die again until we obtain a valid move. Finally, we mark square number I + K.

# After the game finishes (when the pebble is standing on square number N − 1), we calculate the result. The result of the game is the sum of the numbers written on all marked squares.

# For example, given the following array:

#     A[0] = 1
#     A[1] = -2
#     A[2] = 0
#     A[3] = 9
#     A[4] = -1
#     A[5] = -2
# one possible game could be as follows:

# the pebble is on square number 0, which is marked;
# we throw 3; the pebble moves from square number 0 to square number 3; we mark square number 3;
# we throw 5; the pebble does not move, since there is no square number 8 on the board;
# we throw 2; the pebble moves to square number 5; we mark this square and the game ends.
# The marked squares are 0, 3 and 5, so the result of the game is 1 + 9 + (−2) = 8. This is the maximal possible result that can be achieved on this board.

# Write a function:

# class Solution { public int solution(int[] A); }

# that, given a non-empty array A of N integers, returns the maximal result that can be achieved on the board represented by array A.

# For example, given the array

#     A[0] = 1
#     A[1] = -2
#     A[2] = 0
#     A[3] = 9
#     A[4] = -1
#     A[5] = -2
# the function should return 8, as explained above.

# Write an efficient algorithm for the following assumptions:

# N is an integer within the range [2..100,000];
# each element of array A is an integer within the range [−10,000..10,000].

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

