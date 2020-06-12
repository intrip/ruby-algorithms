def slow_pow(a, b)
  result = 1
  b.times do
    result *= a
  end
  result
end

def pow(a, b)
  return 0 if a == 0
  return 1 if b == 0

  tmp = pow(a, b / 2)
  result = tmp * tmp
  result *= a if b % 2 == 1
  result
end

def pow_iter(a, b)
  result = 1
  while b > 0
    result *= a if b % 2 == 1
    a *= a
    b /= 2
  end
  result
end

p slow_pow(3, 9)
p pow(3, 9)
p pow_iter(3, 9)
# 19683

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('slow pow') { 100.times { slow_pow(3, 1000) } }
  x.report('pow') { 100.times { pow(3, 1000) } }
  x.report('pow iter') { 100.times { pow_iter(3, 1000) } }
end
