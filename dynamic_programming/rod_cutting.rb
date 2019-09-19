# Given a rod of length n inches and an array of prices that contains prices of all pieces of size smaller than n.
# Determine the maximum value obtainable by cutting up the rod and selling the pieces.
# For example, if length of the rod is 8 and the values of different pieces are given as following, then the maximum obtainable value is 22

MIN_INT = -1_000

# brute force solution: takes O(2^n) time
def solution(p, n)
  return 0 if n <= 0

  n.times.reduce(MIN_INT) do |max, i|
    [max, p[i] + solution(p, n - (i + 1))].max
  end
end

# uses dynamic programming (top to bottom using memoizing) and solves problem in O(n^2) time
def solution_dp(p, n, memo = [])
  return 0 if n <= 0
  return memo[n] if memo[n]

  memo[n] = n.times.reduce(MIN_INT) do |max, i|
    [max, p[i] + solution_dp(p, n - (i + 1), memo)].max
  end
end

# uses dynamic programming (bottom to top) and solves problem in O(n^2) time
def solution_dp_bu(p, n)
  dp = Array.new(n, MIN_INT)
  # we set p[0] and dp[0] to 0
  dp[0] = 0
  p = p.dup.unshift(0)

  (1..n).each do |i|
    dp[i] = (0..(i - 1)).reduce(MIN_INT) do |max, j|
      [max, dp[j] + p[i - j]].max
    end
  end

  dp.last
end

p = [1, 5, 8, 9, 10, 17, 17, 20]

p solution(p, p.length)
p solution_dp(p, p.length)
p solution_dp_bu(p, p.length)
# should be 22

p = Array.new(200) { rand(100) }
p solution_dp(p, p.length)
p solution_dp_bu(p, p.length)
p solution(p, p.length)

{ 'a' => 'b', 'c' => 'd' }
require 'benchmark'

Benchmark.bmbm do |x|
  # the bottom-up solution is more performant because we do less method calls
  x.report("optimized memoized:") { 1_000.times { solution_dp(p, p.length) }  }
  x.report("optimized bottom up:") { 1_000.times { solution_dp_bu(p, p.length) }  }
end
