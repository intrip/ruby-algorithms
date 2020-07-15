# print infinitely the following sequence:
#
# 0
# 1
# 00
# 01
# 10
# 11
# 000
# 001
# 010
# 011
# 100
# 101
# ...
def print_s
  num = ['0']

  loop do
    puts num.join
    num = succ(num)
  end
end

def succ(num)
  i = num.length - 1
  curry = 1
  while curry > 0 && i >= 0
    curry += 1 if num[i] == '1'
    num[i] = (curry % 2).to_s
    curry /= 2
    i -= 1
  end
  num.unshift('0') if curry > 0
  num
end

print_s
