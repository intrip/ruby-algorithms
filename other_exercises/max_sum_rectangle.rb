# Find the rectanbgle with max sum within the matrix
#
#

# O(n^3*m^3)
def max_sum(matrix)
  return 0 if matrix.length < 1 || matrix[0].length < 1

  rows = matrix.length
  cols = matrix[0].length

  max = -Float::MAX
  # O(n^2*m^2)
  rows.times do |sr|
    cols.times do |sc|
      sr.upto(rows - 1).each do |er|
        sc.upto(cols -1).each do |ec|
          # O(n*m)
          max = [max, compute(matrix, sr, sc, er, ec)].max
        end
      end
    end
  end

  max
end

def compute(matrix, sr, sc, er, ec)
  sum = 0
  sr.upto(er).each do |r|
    sc.upto(ec).each do |c|
      sum += matrix[r][c]
    end
  end
  sum
end

# O(n^2*m^2) time O(n^2*m^2) memory, can improve memory up to O(n*m)
def max_sum_dp(matrix)
  return 0 if matrix.length < 1 || matrix[0].length < 1

  rows = matrix.length
  cols = matrix[0].length

  # start row,col end row, end col
  dp = Array.new(rows) { Array.new(cols) { Array.new(rows) { Array.new(cols, 0) } } }

  max = -Float::MAX
  rows.times do |sr|
    cols.times do |sc|
      sr.upto(rows - 1).each do |er|
        sc.upto(cols -1).each do |ec|
          dp[sr][sc][er][ec] = matrix[er][ec]
          # rect above
          if er > 0
            dp[sr][sc][er][ec] += dp[sr - 1][sc][er - 1][ec]
          end
          # rect left
          if ec > 0
            dp[sr][sc][er][ec] += dp[er][sc][er][ec - 1]
          end
          max = [max, dp[sr][sc][er][ec]].max
        end
      end
    end
  end

  max
end

# O(rows*cols^2) time and O(rows) memory
def max_sum_kadane(matrix)
  rows = matrix.length
  return 0 if rows < 1
  cols = matrix[0].length
  return 0 if cols < 1

  ans = -Float::MAX
  cols.times do |l|
    dp = Array.new(rows, 0)
    l.upto(cols - 1) do |c|
      tsum = 0
      rows.times do |r|
        tsum = 0 if tsum < 0
        tsum += matrix[r][c]
        tsum += dp[r]
        ans = [ans, tsum].max
        dp[r] += matrix[r][c]
      end
    end
  end

  ans
end

m = [
  [ 6,-5, -7, 4, -4],
  [-9, 3, -6, 5,  2],
  [-10, 4, 7, -6, 3],
  [-8, 9, -3, 3, -7]
]
#m = [
#  [1, 4],
#  [-4, 2]
#]
p max_sum(m)
p max_sum_dp(m)
p max_sum_kadane(m)
# should be 17


require 'benchmark'

Benchmark.bmbm do |x|
  x.report('max sum') { 1000.times { max_sum(m) } }
  x.report('max sum dp') { 1000.times { max_sum_dp(m) } }
  x.report('max sum kadane') { 1000.times { max_sum_kadane(m) } }
end

