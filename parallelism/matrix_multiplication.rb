require 'parallel'

# Parralel multiplication of a matrix with a vector
def p_m_v(x, v, method: :t)
  # we assume v.length is the same of x cols
  res = Array.new(v.length, 0)

  case method
  when :t
    parallel_map(0.upto(x.length - 1), type: :threads) do |r|
      0.upto(x[r].length - 1) do |c|
        res[r] += x[r][c] * v[c]
      end
      res[r]
    end
  when :a
    Parallel.map(0.upto(x.length - 1)) do |r|
      0.upto(x[r].length - 1) do |c|
        res[r] += x[r][c] * v[c]
      end
      res[r]
    end
  when :p
    parallel_map(0.upto(x.length - 1), type: :process) do |r|
      0.upto(x[r].length - 1) do |c|
        res[r] += x[r][c] * v[c]
      end
      res[r]
    end
  end
end

# Matrix vector serial multiplication
def m_v(x, v)
  res = Array.new(v.length, 0)

  0.upto(x.length - 1) do |r|
    0.upto(x[r].length - 1) do |c|
      res[r] += x[r][c] * v[c]
    end
  end

  res
end

class JobFactory
  def initialize(arr)
    @arr = arr.to_a  # ensure it's an array even when we receive an enumerator
    @len = @arr.length
    @mutex = Mutex.new
    @index = -1
  end

  def next
    index = @mutex.synchronize { @index += 1 }
    [@arr[index], index] if index < @len
  end
end

CORES = 8
def parallel_map(arr, type:, cores: CORES, &block)
  case type
  when :threads
    parallel_map_thr(arr, cores, &block)
  when :process
    parallel_map_proc(arr, cores, &block)
  else
    raise 'Invalid type given!'
  end
end

def parallel_map_thr(arr, cores)
  jobs = JobFactory.new(arr)
  res_mutex = Mutex.new
  res = []

  1.upto(cores).map do
    Thread.new do
      while set = jobs.next
        el, idx = set

        # NOTE: moving this block in the synchronize would basically mean to make the algorithm serial.
        # This would basically reduce the parallelism to 0 rather than to ~cores.
        result = yield el
        res_mutex.synchronize { res[idx] = result }
      end
    end
  end.map(&:join)

  res
end

def parallel_map_proc(arr, cores)
  child_reads = []
  child_writes = []
  parent_reads = []
  parent_writes = []

  pids = []
  res = []

  1.upto(cores).map do
    # create pipes
    child_read, parent_write = IO.pipe
    parent_read, child_write = IO.pipe
    child_reads << child_read
    child_writes << child_write
    parent_reads << parent_read
    parent_writes << parent_write

    pids << Process.fork do
      # we compute the result in the forked process
      parent_write.close
      parent_read.close

      # work
      until child_read.eof?
        el, idx = Marshal.load(child_read)
        result = yield el
        Marshal.dump([result, idx], child_write)
      end

      child_read.close
      child_write.close
    end
  end

  child_reads.map(&:close)
  child_writes.map(&:close)

  jobs = JobFactory.new(arr)
  loop do
    done = false

    # pass data
    0.upto(pids.length - 1).each do |i|
      if set = jobs.next
        Marshal.dump(set, parent_writes[i])
      else
        parent_writes[i].close
      end
    end

    # read result
    0.upto(pids.length - 1).each do |i|
      if !parent_reads[i].eof?
        el, idx = Marshal.load(parent_reads[i])
        res[idx] = el
      else
        done = true
      end
    end

    break if done
  end

  parent_reads.map(&:close)
  parent_writes.map(&:close)

  res
ensure
  pids.each do |pid|
    Process.kill(:KILL, pid)
  end
end

require 'benchmark'

Benchmark.bmbm do |r|
  # x = Array.new(10) { Array.new(10) { rand(100) } }
  # v = Array.new(10) { rand(100) }
  x = Array.new(60000) { Array.new(1000) { rand(100) } }
  v = Array.new(60000) { rand(100) }

  r1 = nil
  r2 = nil
  r.report("m_v") { r1 = m_v(x, v) }
  if RUBY_PLATFORM =~ /java/
    r.report("p_m_v_t") { r2 = p_m_v(x, v, method: :t) }
  else
    r.report("p_m_v_p") { r2 = p_m_v(x, v, method: :p) }
  end
  r.report("p_m_v_a") { p_m_v(x, v, method: :a) }

  if r1 != r2
    puts "ERROR! The generated result is different than the serial algorithm!"
    p r1, r2
  end
end
