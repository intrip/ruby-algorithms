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
# This can be achieved with DP but a better solution is to use a greedy_algoritm (check the related folder)
INF = 10**99
s = [
  [0,0],
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
  [12, 16],
  [INF,INF]
]

def activity_selection(s, a, b, selected = [])
  max = 0
  for i in a..b do
    if overlaps?(s, selected, i)
      sum = 0
    else
      sum = 1
      selected = selected.dup << i
    end

    max = [
      max,
      sum + activity_selection(s, a, i - 1, selected) + activity_selection(s, i + 1, b, selected)
    ].max
  end

  max
end

def activity_selection_memo(s, a, b, selected = [], memo = {})
  memo_key = "#{a}#{b}#{selected}"
  return memo[memo_key] if memo[memo_key]

  max = 0
  for i in a..b do
    if overlaps?(s, selected, i)
      sum = 0
    else
      sum = 1
      selected = selected.dup << i
    end

    max = [
      max,
      sum + activity_selection_memo(s, a, i - 1, selected, memo) + activity_selection_memo(s, i + 1, b, selected, memo)
    ].max
  end

  memo[memo_key] ||= max
  max
end

def overlaps?(s, selected, i)
  selected.any? do |j|
    s[i][0] >= s[j][0] && s[i][0] <= s[j][1] ||
      s[i][1] >= s[j][1] && s[i][0] <= s[j][1]
  end
end

# We denote by S[i,j] all the activities that starts after activity a[i] and finishes before a[j]
# and by c[i,j] the maximum set of non overlapping activities that starts after a[i] and finishes before a[j]
#
# c[i,j] =  {
#   0 if S[i,j] is empty
#   max{a[k] of S[i,j]} ( c[i,k] + 1 + c[k,j] )
# }
#
# Note that given S[i,j] we need to search in all the activities in between a[i] and a[k] because we have sorted by the end date
# in monotically increasing order.
#
# Takes O(n^3) time to compute.
#
def activity_selection_bottom_up(s, a, b)
  len = b - a + 1
  # c contains the solution
  c = Array.new(len) { Array.new(len, 0) }
  # we start from c1,1,c2,2,c1,2,c2,3,cn knowing that if j-1 < 2 c[i,j] = 0
  # l is the size of the stick, we start from 2 because we already know that the res otherwise is 0
  for l in 2..len do
    for i in 0..(len - l - 1) do
      j = i + l

      for k in (i + 1)..(j - 1) do
        # if the ak is non overlapping
        ak = if s[k][0] > s[i][1] && s[k][1] < s[j][0]
               1
             else
               0
             end
        tmp = c[i][k] + ak + c[k][j]
        if tmp > c[i][j]
          c[i][j] = tmp
        end
      end
    end
  end

  c
end

p activity_selection_bottom_up(s, 0, s.length - 1)[0][s.length - 1]
p activity_selection_memo(s, 1, s.length - 2)
p activity_selection(s, 1, s.length - 2)

require 'benchmark'

Benchmark.bm do |x|
  x.report('normal') { 10.times { activity_selection(s, 1, s.length - 2) } }
  x.report('memo') { 10.times { activity_selection_memo(s, 1, s.length - 2) } }
  x.report('bottom_up') { 10.times { activity_selection_bottom_up(s, 0, s.length - 1) } }
end
