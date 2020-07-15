require 'set'

def get_permutations(string)
  # base case
  if string.length <= 1
    return Set.new [string]
  end

  all_chars_except_last = string[0..-2]
  last_char = string[-1]

  # recursive call: get all possible permutations for all chars except last
  permutations_of_all_chars_except_last = get_permutations(all_chars_except_last)

  # put the last char in all possible positions for each of the above permutations
  permutations = Set.new
  permutations_of_all_chars_except_last.each do |permutation_of_all_chars_except_last|
    (0..all_chars_except_last.length).each do |position|
      permutation = permutation_of_all_chars_except_last[0...position] + last_char + permutation_of_all_chars_except_last[position..-1]
      permutations.add(permutation)
    end
  end

  return permutations
end

# Returns all the possible string permutations.
# For example permutations of 123 are the followings:
#
# 132 123
# 213 231
# 312 321
#
# This function is O(n*n!)
def permutations(str)
  return [str] if str.length == 1

  ans = []
  str.length.times do |i|
    head = str[i]
    tail = str[0, i] + str[(i + 1)..str.length - 1]
    permutations(tail).each do |permutation|
      ans << head + permutation
    end
  end

  ans
end

# using memoizing we can speedup his computation but it still takes O(n!)
def permutations_memo(str, memo = {})
  if memo[str]
    return memo[str]
  end

  len = str.length
  if len == 1
    return Set.new([str])
  end

  res = Set.new([])
  str.length.times do |i|
    head = str[i]
    tail = str[0,i] + str[(i + 1),(len - 1 + i)]
    permutations_memo(tail, memo).each do |permutation|
      res << head + permutation
    end
  end

  memo[str] = res
  res
end

def backtrack(nums, start = 0)
  $ans << nums.dup if start == nums.length

  start.upto(nums.length - 1).each do |i|
    nums[i], nums[start] = nums[start], nums[i]
    backtrack(nums, start + 1)
    nums[i], nums[start] = nums[start], nums[i]
  end
end

def permutations_backtrack(nums)
  $ans= []

  backtrack(nums)
  $ans
end

a = permutations("123")
b = get_permutations("123")
c = permutations_memo("123")
d = permutations_backtrack("123")
p a, b, c, d

require 'benchmark'

Benchmark.bm do |x|
  x.report("permutations") { permutations("123456789") }
  x.report("get_permutations") { get_permutations("123456789") }
  x.report("permutations_memo") { permutations_memo("123456789") }
  x.report("permutations_backtrack") { permutations_backtrack("123456789") }
end

