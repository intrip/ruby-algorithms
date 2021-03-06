# A binary gap within a positive integer N is any maximal sequence of consecutive zeros that is surrounded by ones at both ends in the binary representation of N.

# For example, number 9 has binary representation 1001 and contains a binary gap of length 2. The number 529 has binary representation 1000010001 and contains two binary gaps: one of length 4 and one of length 3. The number 20 has binary representation 10100 and contains one binary gap of length 1. The number 15 has binary representation 1111 and has no binary gaps. The number 32 has binary representation 100000 and has no binary gaps.

# Write a function:

# def solution(n)

# that, given a positive integer N, returns the length of its longest binary gap. The function should return 0 if N doesn't contain a binary gap.

# For example, given N = 1041 the function should return 5, because N has binary representation 10000010001 and so its longest binary gap is of length 5. Given N = 32 the function should return 0, because N has binary representation '100000' and thus no binary gaps.

# Write an efficient algorithm for the following assumptions:

# N is an integer within the range [1..2,147,483,647].

# less performant: allocates more memory and uses a regex, still O(n)
def solution_reg(n)
  n.to_s(2)
    .scan(/(?<=1)0+(?=1)/)
    .map(&:length)
    .max.to_i
end

# more performant, O(n)
def solution(n)
  max_gap = 0
  counting = false
  count = 0

  each_bit(n) do |bit|
    # breakpoint: start or finish counting
    if bit == 1
      unless counting
        max_gap = [max_gap, count].max
        count = 0
        counting = false
      else
        counting = true
      end
    else
      count += 1
    end
  end

  max_gap
end

def each_bit(n)
  loop do
    yield n & 1
    break if (n >>= 1) <= 0
  end
end

p solution_reg(1041)
p solution(1041)
# should be 5
p solution_reg(15)
p solution(15)
# should be 0

require 'benchmark'

Benchmark.bmbm do |bm|
  bm.report("regex solution:") { 100_000.times { solution_reg(1_000_000_123_456) } }
  bm.report("& solution:") { 100_000.times { solution(1_000_000_123_456) } }
end
