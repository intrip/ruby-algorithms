ListItem = Struct.new(:key, :val, :next)
ListItem.class_eval do
  def inspect
    "#{key}@#{val}"
  end
end

class LinkedList
  def initialize
    @head = nil
  end

  # insert an item as new head
  # takes O(1) time
  def insert(key, val)
    if @head == nil
      @head = ListItem.new(key, val, nil)
    else
      l = ListItem.new(key, val, @head)
      @head = l
    end
  end

  def dump
    res = ''
    current = @head

    while current
      res << "#{current.inspect}"
      res << ' -> ' if current.next
      current = current.next
    end

    res
  end

  # deletes a given node
  # Takes O(n) time
  def delete(item)
    # deleting the head
    if item.key == @head.key
      @head = item.next
      return
    end

    current = @head
    while current.next.key != item.key
      current = current.next
    end

    current.next = item.next
  end

  # searches and returns an element in the node
  # takes O(n) time
  def search(key)
    current = @head

    while current && current.key != key
      current = current.next
    end

    current
  end

  def to_s
    res = ''
    current = @head

    while current
      res << current.inspect
      res << " (head)" if @head.key == current.key
      res << "\n"
      current = current.next
    end

    res
  end
end

def build_list(nodes)
  LinkedList.new.tap do |list|
    nodes.each do |k, v|
      puts "Adding #{k},#{v}\n\n"
      list.insert(k, v)
      puts "dump: #{list.dump}\n\n"
      readline
    end
  end
end

# Create the LinkedList
ll = build_list([[1,1], [2,2], [3,3], [4,4], [5,5]])

puts "deleting 2"
ll.delete(ll.search(2))
puts ll.dump
readline

puts "deleting 5(head)"
ll.delete(ll.search(5))
puts ll.dump
readline

require 'benchmark'

Benchmark.bm do |x|
  data = Array.new(1000) { [rand(1000), rand(1000)] }
  x.report('linked list') do
    1_000.times do
      LinkedList.new.tap do |list|
        data.each do |k, v|
          list.insert(k, v)
        end
      end
    end
  end

  x.report('array') do
    1_000.times do
      arr = []
      data.each do |k,v|
        arr << [k,v]
      end
    end
  end
end

puts "Done."
