# general queue implementation using 2 indexes
# low performance because BasicQueue uses ruby C implementation mostly
# head == nil when q is empty and head == tail when q is full
class Queue
  attr_reader :head, :tail, :store

  def initialize(size = 3)
    @head = nil
    @tail = 0
    @store = Array.new(size)
  end

  def enqueue(val)
    raise 'Overflow' if head == tail

    store[tail] = val

    # empty queue
    if head == nil
      @head = tail
    end

    if tail == (store.length - 1)
      @tail = 0
    else
      @tail += 1
    end
  end

  def dequeue
    raise 'Underflow'  if head == nil

    val = store[head]
    if head == (store.length - 1)
      @head = 0
    else
      @head += 1
    end

    # full queue
    if head == tail
      @head = nil
    end

    val
  end

end

# this queue relies on ruby array push and shift
class BasicQueue
  attr_reader :size, :store

  def initialize(size = 3)
    @size = size
    @store = []
  end

  def enqueue(val)
    raise 'Overflow' if store.length == size

    store.push(val)
  end

  def dequeue
    raise 'Underflow' if store.empty?

    store.shift
  end
end

require 'benchmark'

GC.disable
Benchmark.bm do |x|
  x.report("queue: ") do
    q = Queue.new(100000)

    100000.times do |i|
      q.enqueue(i)
    end
    100000.times do
      q.dequeue
    end
  end

  x.report("basic queue: ") do
    q = BasicQueue.new(100000)

    100000.times do |i|
      q.enqueue(i)
    end
    100000.times do |i|
      q.dequeue
    end
  end
end
