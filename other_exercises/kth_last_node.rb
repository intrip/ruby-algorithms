# Given a Linked List and a number n, write a function that returns the value at the n’th node from the end of the Linked List.
# 1,2,3,4,5 k = 2

class LinkedListNode
  attr_accessor :value, :next

  def initialize(value)
    @value = value
    @next  = nil
  end
end

a = LinkedListNode.new("Angel Food")
b = LinkedListNode.new("Bundt")
c = LinkedListNode.new("Cheese")
d = LinkedListNode.new("Devil's Food")
e = LinkedListNode.new("Eccles")

a.next = b
b.next = c
c.next = d
d.next = e

# this uses O(i) space and takes O(n) time
def kth_to_last_node(i, root)
  nodes = [root]
  current = root

  while current = current.next
    nodes << current
    if nodes.length > i
      nodes.shift
    end
  end

  nodes.first
end


# this uses O(1) space and takes O(n) time
def kth_to_last_node_2(i, root)
  previous = root
  current = root

  loop do
    new_current, steps = k_steps(i, current)
    # we reached the end so now we only move by the steps needed in order to
    # reach the end from current but we do it on previous thus the result is
    # the kth last node
    if !new_current
      res = k_steps(steps, previous)
      return res.first
    else
      previous = current
      current = new_current
    end
  end
end

def k_steps(k, node)
  steps = 0
  current = node

  while current && steps < k
    current = current.next
    steps += 1
  end

  [current, steps]
end

p kth_to_last_node_2(2, a).value
# returns the node with value "Devil's Food" (the 2nd to last node)
