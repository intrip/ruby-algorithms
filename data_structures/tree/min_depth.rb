=begin
Given a binary tree, find its minimum depth. The minimum depth is the number of nodes along the shortest path from root node down to the nearest leaf node.

For example, minimum height of below Binary Tree is 2.
Example Tree

            1
          /   \
         2     3
        / \
       4   5

Note that the path must end on a leaf node. For example, minimum height of below Binary Tree is also 2.

          10
        /
      5
=end

class Node
  attr_accessor :id, :left, :right

  def initialize(id, left=nil, right=nil)
    @id = id
    @left = left
    @right = right
  end
end

# Complexity O(n)
# this algorithm may pass all the tree even if the topmost has only 1 child
def min_depth(node)
  # edge case: when called with nil
  if node == nil
    return 0
  end

  # no childs i return my depth
  if node.left == nil && node.right == nil
    return 1
  end

  # if right subtree nil go to the left
  if node.right == nil
    min_depth(node.left)+1
  end

  # if left subtree nil go to the right
  if node.left == nil
    min_depth(node.right)+1
  end

  # i have both left and right child then navigate in both sides
  [min_depth(node.right),min_depth(node.left)].min + 1
end

# In this case we compare the tree in a traversal order using a queue structure
def min_depth_opt(node)
  # edge case: when called with nil
  if node == nil
    return 0
  end

  # create the initial q
  q = [{node: node, depth: 1}]

  while(q.size > 0)
    item = q.pop

    node = item[:node]
    depth= item[:depth]

    # i am done: leaf node
    if node.left == nil and node.right ==nil
      return depth
    end

    # if have left
    if node.left != nil
      q.push({node: node.left, depth: depth +1 })
    end

    # if have right
    if node.right != nil
      q.push({node: node.right, depth: depth +1 })
    end
  end

end

n_4 = Node.new("4")
n_5 = Node.new("5")
n_2 = Node.new("2",n_4,n_5)
n_3 = Node.new("3")
root = Node.new("1",n_2,n_3)

require 'benchmark'

Benchmark.bm do |x|
  x.report("min_depth_opt: ") { for i in 1..1000000; min_depth_opt(root) end;}
  x.report("min_depth: ") { for i in 1..1000000; min_depth(root) end;}
end
puts "\n"
puts "min_depth res: #{min_depth(root)}"
puts "min_depth_opt res: #{min_depth_opt(root)}"


