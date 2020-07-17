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
#   _    5     6     7
#  _ _ 10 11 _  13 14 15
#
# => [1,2,5,10,11,13,14,15,7,3]
#
root = Node.new(1,
                Node.new(2,
                          Node.new(5, Node.new(10), Node.new(11))),
                Node.new(3,
                          Node.new(6, nil, Node.new(13)),
                          Node.new(7, Node.new(14), Node.new(15)))
               )

SEP = '-'
def tree_border(root)
  ans = []
  return ans unless root

  ans.push(root.val) unless leaf?(root)

  current = root.left
  while current && !leaf?(current)
    ans.push(current.val)
    if current.left
      current = current.left
    elsif current.right
      current = current.right
    else
      current = false
    end
  end

  stack = [root]
  while current = stack.pop
    if leaf?(current)
      ans.push(current.val)
    else
      stack.push(current.right) if current.right
      stack.push(current.left) if current.left
    end
  end

  current = root.right
  stack = []
  while current && !leaf?(current)
    stack.push(current.val)
     if current.right
      current = current.right
    elsif current.left
      current = current.left
    else
      current = false
    end
  end
  ans.concat(stack.reverse)
end

def leaf?(node)
  node && node.left.nil? && node.right.nil?
end

p tree_border(root)
