# A non-empty array A consisting of N integers is given. Array A represents numbers on a tape.

# Any integer P, such that 0 < P < N, splits this tape into two non-empty parts: A[0], A[1], ..., A[P − 1] and A[P], A[P + 1], ..., A[N − 1].

# The difference between the two parts is the value of: |(A[0] + A[1] + ... + A[P − 1]) − (A[P] + A[P + 1] + ... + A[N − 1])|

# In other words, it is the absolute difference between the sum of the first part and the sum of the second part.

# For example, consider array A such that:

#   A[0] = 3
#   A[1] = 1
#   A[2] = 2
#   A[3] = 4
#   A[4] = 3
# We can split this tape in four places:

# P = 1, difference = |3 − 10| = 7 
# P = 2, difference = |4 − 9| = 5 
# P = 3, difference = |6 − 7| = 1 
# P = 4, difference = |10 − 3| = 7 
# Write a function:

# def solution(a)

# that, given a non-empty array A of N integers, returns the minimal difference that can be achieved.

# For example, given:

#   A[0] = 3
#   A[1] = 1
#   A[2] = 2
#   A[3] = 4
#   A[4] = 3
# the function should return 1, as explained above.

# Write an efficient algorithm for the following assumptions:

# N is an integer within the range [2..100,000];
# each element of array A is an integer within the range [−1,000..1,000].

# This solution is O(n^2)
def solution(a)
  l = a[0]
  r = a[1..(a.length - 1)].sum
  min = (l - r).abs

  (1..(a.length - 2)).each do |p|
    l = a[0..p].sum
    r = a[(p + 1)..-1].sum
    new_min = (l - r).abs

    min = new_min if new_min < min
  end

  min
end

# This opt solution is O(n)
def solution_opt(a)
  l = a[0]
  r = a[1..(a.length - 1)].sum
  min = (l - r).abs

  (1..(a.length - 2)).each do |p|
    l += a[p]
    r -= a[p]
    new_min = (l - r).abs

    min = new_min if new_min < min
  end

  min
end

arr = [3, 1, 2, 4, 3]
p solution(arr)
p solution_opt(arr)
# should be 1

require 'benchmark'

arr = Array.new(100) { rand(100) }
Benchmark.bm do |x|
  x.report("solution O(n^2)") { 1_000.times { solution(arr) } }
  x.report("solution optimized O(n)") { 1_000.times { solution_opt(arr) } }
end
