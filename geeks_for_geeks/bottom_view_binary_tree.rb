# https://practice.geeksforgeeks.org/problems/bottom-view-of-binary-tree/1
# Given a binary tree, print the bottom view from left to right.
# A node is included in bottom view if it can be seen when we look at the tree from bottom.

#                       20
#                     /    \
#                   8       22
#                 /   \        \
#               5      3       25
#                     /   \
#                   10    14

# For the above tree, the bottom view is 5 10 3 14 25.
# If there are multiple bottom-most nodes for a horizontal distance from root, then print the later one in level traversal. For example, in the below diagram, 3 and 4 are both the bottommost nodes at horizontal distance 0, we need to print 4.

#                       20
#                     /    \
#                   8       22
#                 /   \     /   \
#               5      3 4     25
#                      /    \
#                  10       14

# For the above tree the output should be 5 10 4 14 25.

# Input Format:
# The first line of input contains T denoting number of testcases. T testcases follow. Each testcase contains two lines of input. The first line contains the number of edges. The second line contains the relation between nodes.

# Output Format:
# The function should print nodes in bottom view of Binary Tree. Your code should not print a newline, it is added by the caller code that runs your function.

# User Task:
# This is a funcitonal problem, you don't need to care about input, just complete the function bottomView() which should print the bottom view of the given tree.

# Constraints:
# 1 <= T <= 30
# 0 <= Number of nodes <= 100
# 0 <= Data of a node <= 1000

# Example:
# Input:
# 2
# 2
# 1 2 R 1 3 L
# 4
# 10 20 L 10 30 R 20 40 L 20 60 R

# Output:
# 3 1 2
# 40 20 60 30

# Explanation:
# Testcase 1:  First case represents a tree with 3 nodes and 2 edges where root is 1, left child of 1 is 3 and right child of 1 is 2.

class Node
  attr_accessor :k, :l, :r

  def initialize(k, l=nil, r=nil)
    @k = k
    @l = l
    @r = r
  end
end


# This algorithm takes O(n) time to complete and uses O(k) extra memory
def bottom_view(root)
  path = [[root, 0]]
  nodes_by_height = { 0 => root }
  min_height = 0

  loop do
    current, height = path.shift
    break unless current

    if current.l
      path << [current.l, height - 1]
      nodes_by_height[height - 1] = current.l
      min_height = (height - 1) if  min_height > (height - 1)
    end
    if current.r
      path << [current.r, height + 1]
      nodes_by_height[height + 1] = current.r
    end
  end

  i = min_height
  while nodes_by_height[i] do
    print "#{nodes_by_height[i].k} "
    i += 1
  end
end

#      10
#     /  \
#    20  30
#   / \
#  40 60
n_60 = Node.new(60)
n_40 = Node.new(40)
n_20 = Node.new(20, n_40, n_60)
n_30 = Node.new(30)
root = Node.new(10, n_20, n_30)

bottom_view(root)
# expected: 40 20 60 30
