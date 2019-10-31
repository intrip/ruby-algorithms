# Combinations in a String of Digits
# Given an input string of numbers, find all combinations of numbers that can be formed using digits in the same order.

# Examples:

# Input : 123
# Output :1 2 3
#         1 23
#         12 3
#         123

# Input : 1234
# Output : 1 2 3 4
#         1 2 34
#         1 23 4
#         1 234
#         12 3 4
#         12 34
#         123 4
#         1234

# Time complexity is n*2^n
def solution(str)
  res = []
  for grp_size in 1..str.length do
    head = str[0,grp_size]
    tail = str[(grp_size)..(str.length - 1)]

    if tail.length > 1
      solution(tail).each do |tail_s|
        res << head + ' ' + tail_s
      end
    elsif tail.empty?
      res << head
    else
      res << head + ' ' + tail
    end
  end

  res
end

p solution('1234')
