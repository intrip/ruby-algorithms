require 'byebug'

Node = Struct.new(:val, :next)

node8 = Node.new(8,nil)
node7 = Node.new(7,node8)
node6 = Node.new(6,node7)
node5 = Node.new(5,node6)
node4 = Node.new(4,node5)
node3 = Node.new(3,node4)
node2 = Node.new(2,node3)
node1 = Node.new(1,node2)

def print_list(node)
  current_node = node
  print "#{current_node.val}->"
  while(current_node = current_node.next)
    print "#{current_node.val}->"
  end
  puts 'NULL'
end

# Reverse a linked list with groups of size k with a cost of O(n)
# 
# @example
# 
# 1->2->3->4->5->6->7->8->NIL
# reverse_list(node1,4)
# => 
# 4->3->2->1->8->7->6->5->NIL
#
$list_head = nil
def reverse_list(node,k)
  current_node = node
  previous_node = nil
  counter = 0
  new_head = nil

  while(counter < k && current_node)
    $list_head ||= current_node if counter == (k-1)
    new_head = current_node

    next_node = current_node.next
    current_node.next = previous_node
    previous_node = current_node
    current_node = next_node

    counter += 1
  end

  node.next = reverse_list(current_node,k) if current_node
  new_head
end


print_list(node1)

reverse_list(node1,3)
print_list($list_head)