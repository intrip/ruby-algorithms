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

def quick_fib(n)
  (((1 + Math.sqrt(5)) / 2) ** n / Math.sqrt(5)).round
end

Benchmark.bm do |x|
  x.report("fib 30 recursive: ") { puts fib(30) }
  x.report("fib 30 formula: ") { puts quick_fib(30) }
end
