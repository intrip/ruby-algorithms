class Node
  include Comparable

  attr_accessor :key

  def initialize(key)
    @key = key
  end

  def <=>(other)
    if key == Heap::INF && other.key == Heap::INF ||
        key == Heap::MINUS_INF && other.key == Heap::MINUS_INF
      return 0
    end
    if key == Heap::INF || other.key == Heap::MINUS_INF
      return 1
    end
    if key == Heap::MINUS_INF || other.key == Heap::INF
      return -1
    end

    key <=> other.key
  end
end

# A Heap is a special Tree-based data structure in which the tree is a complete binary tree. Generally, Heaps can be of two types:
# Max-Heap: In a Max-Heap the key present at the root node must be greatest among the keys present at all of it’s children.
#           The same property must be recursively true for all sub-trees in that Binary Tree.
# Min-Heap: In a Min-Heap the key present at the root node must be minimum among the keys present at all of it’s children.
#           The same property must be recursively true for all sub-trees in that Binary Tree.
#
# Example of Min-Heap
#
#            10                      10
#         /      \               /       \
#       20        100          15         30
#      /                      /  \        /  \
#    30                     40    50    100   40
#
class Heap
  INF = Object.new
  MINUS_INF = Object.new

  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def root
    @nodes[0]
  end

  def left(i)
    (i + 1) * 2 - 1
  end

  def right(i)
    (i + 1) * 2
  end

  def parent(i)
    return 0 if i == 0

    (i + 1) / 2 - 1
  end

  def dump(i = 0)
    return 'empty heap' unless nodes.any?

    res = nodes[i].key.to_s

    has_childrens = nodes[left(i)] || nodes[right(i)]
    if has_childrens
      res += "("
      res += "#{dump(left(i))}," if nodes[left(i)]
      res += dump(right(i)) if nodes[right(i)]
      res += ")"
    end

    res
  end

  def last_i
    return nil if nodes.none?

    nodes.length - 1
  end

  def insert(key)
    nodes.push(Node.new(MINUS_INF))
    increase_key(last_i, key)
  end

  def delete(i)
    swap(i, last_i)
    nodes.pop
    heapify(i)
  end

  def increase_key(i, key)
    raise "i needs to be >= 0, given: #{i}" if i.nil? || i < 0
    raise "Cannot increase key because the original key is higher" if nodes[i] >= Node.new(key)

    nodes[i].key = key
    while !match_child_parent_relation?(nodes[i], nodes[parent(i)])
      swap(i, parent(i))
      i = parent(i)
    end
  end

  # to make this work we need the following precondition:
  # heap rooted at i is not valid but heaps rooted at left(i) and right(i) are valid heaps
  def heapify(i)
    l = left(i)
    r = right(i)

    new_subroot = i
    if nodes[l] && !match_child_parent_relation?(nodes[l], nodes[new_subroot])
      new_subroot = l
    end
    if nodes[r] && !match_child_parent_relation?(nodes[r], nodes[new_subroot])
      new_subroot = r
    end

    if new_subroot != i
      swap(i, new_subroot)
      heapify(new_subroot)
    end
  end

  def extract
    return nil if nodes.empty?

    swap(0, last_i)
    res = nodes.pop
    heapify(0)

    res.key
  end

  def empty?
    nodes.empty?
  end

  class << self
    def build(arr)
      heap = new
      heap.nodes = arr.map { |k| Node.new(k) }
      from = (arr.length / 2) - 1
      from.downto(0).each do |i|
        heap.heapify(i)
      end

      heap
    end
  end

  private

  def swap(i, j)
    nodes[i], nodes[j] = nodes[j], nodes[i]
  end

  def match_child_parent_relation?
    # implement in subclasses
  end
end

class MinHeap < Heap
  alias_method :extract_min, :extract

  def match_child_parent_relation?(child, parent)
    child >= parent
  end

  def min
    nodes[0]
  end
end

class MaxHeap < Heap
  alias_method :extract_max, :extract

  def match_child_parent_relation?(child, parent)
    child <= parent
  end

  def max
    nodes[0]
  end
end

def build_heap(klass, nodes)
  klass.new.tap do |heap|
    nodes.each do |k|
      puts "Adding #{k}\n\n"
      heap.insert(k)
      puts "dump: #{heap.dump}\n\n"
      readline
    end
  end
end

def driver
  nodes = [10, 12, 2, 4, 1, 15, 20]
  puts "Min heap with insert"
  build_heap(MinHeap, nodes)

  puts "Min heap with build"
  mh = MinHeap.new
  mh = MinHeap.build([10,12,2,4,1,15,20])
  puts mh.dump
  readline
  puts "Extract min and dump"
  puts mh.extract_min
  puts mh.dump
  readline

  puts "Max heap with insert"
  build_heap(MaxHeap, nodes)

  puts "Max heap with build"
  mh = MaxHeap.build([10,12,2,4,1,15,20])
  puts mh.dump
  readline
  puts "Delete 12"
  mh.delete(1)
  readline
  puts mh.dump
  puts "Extract max and dump"
  puts mh.extract_max
  puts mh.dump
  readline
end

def bench
  puts "Benchmarking insert vs build, build is mostly faster because does less memory allocation."

  require 'benchmark'

  Benchmark.bm do |x|
    x.report("build") do
      1000.times do
        arr = Array.new(100) { rand(1000) }
        MaxHeap.build(arr)
      end
    end

    x.report("insert") do
      1000.times do
        arr = Array.new(100) { rand(1000) }
        MaxHeap.new.tap do |mh|
          arr.each { |i| mh.insert(i) }
        end
      end
    end
  end
end

driver
bench
puts 'Done.'
