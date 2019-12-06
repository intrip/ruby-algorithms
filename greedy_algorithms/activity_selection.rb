# Each activity aj has a sart time sj and a finish time fj
# We receive in input an array of activites and need to select
# the max activities which doesn't overlap that is, given activity
# ai and aj: sj >= fi or si >= fj
#
# We also know that the finish time of activities is stored in monotically
# increasing order.
#
# We need to find the maximum-size subset of mutually compatible activities.
#
s = [
  [1, 4],
  [3, 5],
  [0, 6],
  [5, 7],
  [3, 9],
  [5, 9],
  [6, 10],
  [8, 11],
  [8, 12],
  [2, 14],
  [12, 16]
]

# This is much better then the DP solution, this in fact takes O(n) time to compute compared to the O(n^3) DP solution.
def activity_selection(s, a, b)
  sol = 1
  i = a
  offset = 1
  while (i + offset) <= b
    if s[i][1] < s[i + offset][0]
      sol += 1
      i += offset
      offset = 1
    else
      offset += 1
    end

  end

  sol
end

p activity_selection(s, 0, s.length - 1)

require 'benchmark'

Benchmark.bm do |x|
  x.report { 10.times { activity_selection(s, 0, s.length - 1) } }
end
