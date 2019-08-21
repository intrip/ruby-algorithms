# An array A consisting of N different integers is given. The array contains integers in the range [1..(N + 1)], which means that exactly one element is missing.

# Your goal is to find that missing element.

# Write a function:

# def solution(a)

# that, given an array A, returns the value of the missing element.

# For example, given array A such that:

#   A[0] = 2
#   A[1] = 3
#   A[2] = 1
#   A[3] = 5
# the function should return 4, as it is the missing element.

# Write an efficient algorithm for the following assumptions:

# N is an integer within the range [0..100,000];
# the elements of A are all distinct;

def solution(a)
  # we could do radix sort and then loop over all the items in order to find the missing element
  # in the ordered list or use the Gauss theorem: https://study.com/academy/lesson/finding-the-sum-of-consecutive-numbers.html
  #
  # if we use the Gauss theorem we can do:
  # sum = (1 + N+1) * ( N / 2 )
  #
  # if (1 + N+1) % 2 == 1 we need to sum also (n+1+1)/2 + 1
  #
  # then remove every item from the sum: the remainder is the missing number
  len = a.length
  sum = (1 + len + 1) * ((len + 1) / 2)
  sum += ((len + 1) / 2.0).ceil unless (len + 1) % 2 == 0

  a.reduce(sum) do |sum, i|
    sum - i
  end
end

a = [2, 3, 1, 5]
p solution(a)
# should be 4
