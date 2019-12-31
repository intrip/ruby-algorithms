# We need to compute the longest common substring between 2 strings.

$loops = 0
# This is the brute force solution which takes
# O(n2*m*2) time. The worst case occurs only if the common substring is very long.
#
# The result is the start and end index of the longest common substring in s1.
def max_substr(s1, s2)
  s1 = s1.chars
  s2 = s2.chars
  a = 0
  b = 0
  max = 0

  for i in 0..(s1.length - 1)
    for j in 0..(s2.length - 1)
      ta, tb = max_substr_at(s1, s2, i, j)
      tmax = tb - ta
      if tmax > max
        max = tmax
        a = ta
        b = tb
      end
    end
  end

  [a, b]
end

def max_substr_at(s1, s2, a, b)
  a2 = a
  b2 = b
  while a2 < s1.length &&
      b2 < s2.length &&
      s1[a2] == s2[b2]
    a2 += 1
    b2 += 1
  end

  $loops += a2 - a + 1
  [a, a2]
end

# We use dynamic programming bottom up to compute the max common substring.
# In order to obtain the max substring of i,j we just need the max lenght of the
# substring in i - 1, j - 1.
#
# For example given the following strings "abdegi", "gbdg" the common
# substring is "bd" with the count of 2 of as you can see from the table below:
#
#    |  a | b | d | e | g | i
#  g |  0 | 0 | 0 | 0 | 1 | 0
#  b |  0 | 1 | 0 | 0 | 0 | 0
#  d |  0 | 0 | 2 | 0 | 0 | 0
#  g |  0 | 0 | 0 | 0 | 1 | 0
#
#  The result is the start and end index of the longest common substring in s1.
#  Takes O(n*m) time.
def max_substr_dp(s1, s2)
  s1 = [nil] + s1.chars
  s2 = [nil] + s2.chars
  # the cache has the initial value of 0
  c = Array.new(s1.length) { Array.new(s2.length, 0) }
  max = 0
  a = 0
  b = 0

  for i in 1..(s1.length - 1)
    for j in 1..(s2.length - 1)
      $loops += 1
      if s1[i] == s2[j]
        c[i][j] = c[i - 1][j - 1] + 1
        if c[i][j] > max
          max = c[i][j]
          a = i - max
          b = i
        end
      else
        c[i][j] = 0
      end
    end
  end

  [a, b]
end

s1 = "thissharedsart"
s2 = "thesharedpart"

p max_substr(s1, s2)
p max_substr_dp(s1, s2)

require 'benchmark'

Benchmark.bm do |x|
  chars = ('a'..'z').to_a
  s1 = Array.new(100) { chars.sample }.join
  s2 = Array.new(100) { chars.sample }.join

  p s1, s2
  x.report("max sub") { 1.times { max_substr(s1, s2) } }
  p $loops
  $loops = 0
  x.report("max sub dp") { 1.times { max_substr_dp(s1, s2) } }
  p $loops
  p max_substr(s1, s2), max_substr_dp(s1, s2)
end
