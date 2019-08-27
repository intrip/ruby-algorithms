require 'byebug'

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

  def render
    print nodes.map(&:key).join(' ')
    print "\n"
  end

  def last_i
    return 0 if nodes.none?

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

  def extract
    swap(0, last_i)
    res = nodes.pop
    heapify(0)

    res.key
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

puts "Min heap with insert"
mh = MinHeap.new
mh.insert(10)
mh.insert(12)
mh.insert(2)
mh.insert(4)
mh.insert(1)
mh.insert(15)
mh.insert(20)
mh.render

puts "Min heap with build"
mh = MinHeap.new
mh = MinHeap.build([10,12,2,4,1,15,20])
mh.render
puts "Extract min and render"
puts mh.extract_min
mh.render

puts "Max heap with insert"
mh = MaxHeap.new
mh.insert(10)
mh.insert(12)
mh.insert(2)
mh.insert(4)
mh.insert(1)
mh.insert(15)
mh.insert(20)
mh.render

puts "Max heap with build"
mh = MaxHeap.build([10,12,2,4,1,15,20])
mh.render
puts "Delete 12"
mh.delete(1)
mh.render
puts "Extract max and render"
puts mh.extract_max
mh.render
