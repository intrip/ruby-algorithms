require 'benchmark'

# enable tail call optimization
RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

# This method can also be speeded up with dynamic programming
# this function is tail recursive because always returns a function or a value
def fib(n, a = 0, b = 1)
  return a if n == 0
  return b if n == 1 && a == 0

  fib(n - 1, b, a + b)
end

# This approximation allows to calculate fib in O(1) using an approximation
# the result is aproximately correct because when we have bigger values we have
# rounding errors
#
# Fibonacci series grows exponentially following the golden ratio (1 + sqrt(5)) / 2
def quick_fib(n)
  (((1 + Math.sqrt(5)) / 2) ** n / Math.sqrt(5)).round
end

Benchmark.bm do |x|
  x.report("fib recursive: ") { puts fib(100) }
  x.report("fib formula: ") { puts quick_fib(100) }
end
