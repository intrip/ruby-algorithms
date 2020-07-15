# frozen_string_literal: true

class Node
  attr_reader :val, :left, :right

  def initialize(val, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

#           1
#     2           3
#   4    5     6     7
#  8 9 10 11 _  13 14 15
#
# => [1,2,4,8,9,10,11,6,13,14,15,7,3]
SEP = '-'
def tree_border(root)
  return [] unless root

  left = []
  current = root.left
  while current && current.left
    left.push(current.val)
    current = current.left
  end

  leaves = []
  stack = [root]
  while current = stack.pop
    stack.push current.right if current.right
    stack.push current.left if current.left
    if current.left.nil? || current.right.nil?
      leaves.push(current.val)
    end
  end

  right = []
  current = root.right
  while current && current.right
    right.push(current.val)
    current = current.right
  end

  [root.val] + left + leaves + right.reverse
end


root = Node.new(1,
                Node.new(2,
                          Node.new(4, Node.new(8), Node.new(9)),
                          Node.new(5, Node.new(10), Node.new(11))),
                Node.new(3,
                          Node.new(6, nil, Node.new(13)),
                          Node.new(7, Node.new(14), Node.new(15)))
               )

p tree_border(root)
