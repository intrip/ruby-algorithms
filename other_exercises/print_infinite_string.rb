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
