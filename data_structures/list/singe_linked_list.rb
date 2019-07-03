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
  def insert(key, val)
    if @head == nil
      @head = ListItem.new(key, val, nil)
    else
      l = ListItem.new(key, val, @head)
      @head = l
    end
  end

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

# Create the LinkedList
ll = LinkedList.new
l1 = ll.insert(1,1)
l2 = ll.insert(2,2)
l3 = ll.insert(3,3)
l4 = ll.insert(4,4)
l5 = ll.insert(5,5)

puts ll

puts "deleting l2"
ll.delete(l2)

puts ll

puts "deleting l5 (head)"
ll.delete(l5)

puts ll

puts "Searching 3"
puts ll.search(3).inspect
