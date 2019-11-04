# We need to build and optimal BST by knowing for each key
# the probability to fetch it and by also knowing the probability to fetch for keys not in Ki
#
# below there is a sample table:
#
# i |  0    1   2    3    4    5
# Pi|     0.15 0.10 0.05 0.10 0.20
# Qi|0.05 0.10 0.05 0.05 0.05 0.10
#
# Pi represent the probability to fetch Ki whilst Qi the probability to fetch a value <= i:
# Every search is either successfull or unsuccessfull so we have:
#
# sum(Pi) + sum(Qi) = 1
#
# O(n^3) time complexity
INF = 2**99
def optimal_bst(p, q, n)
  # e[i.j] is the min(E[search cost in T]) with keys within i,j
  # First index starts ends in n+1 because we need to compute e[n+1,n] to compute the dummy key Dn
  # Last index start from 0 because we need to compute e[1,0] for the dummy key D0
  e = Array.new(n + 2) { Array.new(n + 1) }
  # w is the cost of increasing the subtree depth by 1
  w = Array.new(n + 2) { Array.new(n + 1) }
  # the key to use as root
  root = Array.new(n + 1) { Array.new(n + 1) }

  for i in 1..(n + 1) do
    e[i][i - 1] = q[i - 1]
    w[i][i - 1] = q[i - 1]
  end

  for l in 1..n do
    for i in 1..(n - l + 1) do
      j = i + l - 1
      e[i][j] = INF
      w[i][j] = w[i][j - 1] + p[j] + q[j]
      # we try all the possible r as root in i..j
      for r in i..j do
        t = e[i][r - 1] + w[i][j] + e[r + 1][j]
        t = t.round(2)
        if t < e[i][j]
          e[i][j] = t
          root[i][j] = r
        end
      end
    end
  end

  [e, root]
end

require 'byebug'
def print_optimal_bst(root, i, j, parent = nil, direction = nil)
  k = root.dig(i, j)

  if i > j
    puts "d#{i - 1} is #{direction} child of k#{parent}"
    return
  end

  print "k#{k} is the "
  if parent.nil?
    puts "root"
  else
    puts "#{direction} child of k#{parent}"
  end

  print_optimal_bst(root, i, k - 1, k, 'left')
  print_optimal_bst(root, k + 1, j, k, 'right')
end

pi = [nil, 0.15, 0.10, 0.05, 0.10, 0.20]
qi = [0.05, 0.10, 0.05, 0.05, 0.05, 0.10]
e, root = optimal_bst(pi, qi, 5)

print_optimal_bst(root, 1, 5)
