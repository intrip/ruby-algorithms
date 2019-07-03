require 'benchmark'

def fib(n)
  return 0 if n == 0
  return 1 if n == 1 || n == 2

  fib(n - 1) + fib(n - 2)
end

def quick_fib(n)
  (((1 + Math.sqrt(5)) / 2) ** n / Math.sqrt(5)) #.round
end

Benchmark.bm do |x|
  # x.report("fib 40 recursive: ") { puts fib(40) }
  x.report("fib 40 formula: ") { puts quick_fib(6) }
end

