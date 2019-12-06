# The knapsack problem or rucksack problem is a problem in combinatorial optimization: Given a set of items,
# each with a weight and a value, determine the number of each item to include in a collection so that the total weight
# is less than or equal to a given limit and the total value is as large as possible.
# It derives its name from the problem faced by someone who is constrained by a fixed-size knapsack and must fill it with the most valuable items.


# the size of the items
s = [10, 20,  30,  30, 40,  50,  50, 60, 70,  30, 80,  90, 100, 110, 120, 130]
# the price of the items
p = [60, 100, 120, 100, 120, 100, 200, 60, 120, 80, 110, 50, 90,  150, 55,  22]
# the knapsack size
k = 300
# k = 50

# this is the brute force solution which takes 2^n exponential time to compute.
def knapsack(s, p, k, max = 0)
  new_max = max

  for i in 0..(s.length - 1)
    next if k < s[i]

    new_max = [new_max, knapsack(remove_i(s,i), remove_i(p,i), k - s[i], max + p[i])].max
  end

  new_max
end

def knapsack_memo(s, p, k, max = 0, memo = {})
  memo_k = "#{s.to_s}_#{p.to_s}_#{k}"
  return memo[memo_k] if memo[memo_k]

  new_max = max
  for i in 0..(s.length - 1)
    next if k < s[i]

    new_max = [new_max, knapsack_memo(remove_i(s,i), remove_i(p,i), k - s[i], max + p[i], memo)].max
  end

  memo[memo_k] = new_max
end

def remove_i(a,i)
  a.dup.tap { |a| a.delete_at(i) }
end

def knapsack_bottom_up_wn(s, p, k)
  # adds the initial zero value to the data
  s = s.unshift(0)
  p = p.unshift(0)
  # create c[i,k] = 0
  c = Array.new(s.length) { Array.new(k + 1, 0) }

  # we need to compute the following recursion:
  # c[i,k] = max(c[i,k], c[i,k - s[k]] + p[k])
  # in order to compute the previous c[i,k] we end up in
  # this takes O(nK) time complexity
  # computing all the possible k sizes starting from 0 upto k
  1.upto(s.length - 1) do |i|
    1.upto(k).each do |tk|
      # not enough space for this item
      if tk < s[i]
        c[i][tk] = c[i - 1][tk]
      else
        c[i][tk] = [c[i - 1][tk], c[i - 1][tk - s[i]] + p[i]].max
      end
    end
  end

  c
end

def knapsack_bottom_up_n3(s, p, k)
  # adds the initial zero value to the data
  s = s.unshift(0)
  p = p.unshift(0)
  # create c[i,k] = 0
  c = Array.new(s.length) { Array.new(k + 1, 0) }

  # we need to compute the following recursion:
  # c[i,k] = max(c[i,k], c[i,k - s[k]] + p[k])
  # this takes O(n^3) time complexity, it's quicker than the wn solution when n << k
  1.upto(s.length - 1) do |i|
    # we compute all the values needed for the larger i
    (s.length - 2).downto(0).each do |l|
      tk = k
      # when l is 0 we compute c[0][i][k]
      l.downto(0) do |j|
        tk = tk - s[j]

        # set the value only if valid
        if tk >= s[i]
          c[i][tk] = [c[i - 1][tk], c[i - 1][tk - s[i]] + p[i]].max
        end
      end
    end
  end

  c
end

p knapsack(s, p, k)
p knapsack_memo(s, p, k)
c = knapsack_bottom_up_wn(s, p, k)
p c[-1][-1]
c = knapsack_bottom_up_n3(s, p, k)
p c[-1][-1]

require 'benchmark'

Benchmark.bm do |x|
  x.report('knapsack') { |x| 1.times { knapsack(s, p, k) } }
  x.report('knapsack_memo') { |x| 1.times { knapsack_memo(s, p, k) } }
  x.report('knapsack_bottom_up_wn') { |x| 1.times { knapsack_bottom_up_wn(s, p, k) } }
  x.report('knapsack_bottom_up_n3') { |x| 1.times { knapsack_bottom_up_n3(s, p, k) } }
end
