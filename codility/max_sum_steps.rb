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

MAX_DICE = 6
MIN_VAL = -10_000

def solution(a)
  puts "dynamic programming sol:"
  puts max_sub_dp(a)
  puts "unoptimized sol:"
  puts max_sub(a, 0, a.length - 1, a[0])
end

# this takes ~O(2^N-2 - 2^N-8) => O(2^N)
def max_sub(a, start_idx, end_idx, tmax)
  (1..MAX_DICE).map do |dice|
    next_idx = start_idx + dice
    # out of bound
    next MIN_VAL if next_idx > (a.length - 1)
    # reached end_idx
    next tmax + a[next_idx] if next_idx == (a.length - 1)

    max_sub(a, start_idx + dice, end_idx, tmax + a[next_idx])
  end.max
end

# uses dynamic programming (bottom up) to build the solution
def max_sub_dp(a)
  dp = Array.new(a.length)
  dp[0] = a[0]

  (1..(a.length - 1)).each do |i|
    max = MIN_VAL

    # compute the best value we can reach up to i from all the previous indexes
    (1..MAX_DICE).each do |dice|
     if i - dice >= 0
       max = [dp[i - dice] + a[i], max].max
     end

     dp[i] = max
    end
  end

  dp.last
end

# arr = [1,-2, 0, 9, -1, -2]
# should be 8
# p solution(arr)
# p max_sub_dp(arr)

# arr = [1,-2, 0, 9, -1, -3, -5, -1, -1, -2, -4, -1, -1 -1, -2]
# should be 7
# p solution(arr)

arr = Array.new(22) { rand(2) == 0 ? rand(1000) : (rand(1000) * - 1) }
solution(arr)
