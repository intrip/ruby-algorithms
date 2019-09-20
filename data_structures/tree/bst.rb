require_relative '../utils/print_binary_tree.rb'

# BST is a Binary search tree
#
# The tree has the following property: for every node his left node are <= then the parent and
# the parent is <= than his right node.
# This property allows to do all the important operation in O(h) == log(n) (if the tree is balanced)
#
class Node
  KEY_SPAN = 3

  attr_reader :key
  attr_accessor :p, :l, :r, :height

  def initialize(key, p, l, r, height)
    @key = key
    @p = p
    @l = l
    @r = r
    @height = height
  end

  def render(padding)
    print pad(*padding, key.to_s.rjust(Node::KEY_SPAN))
  end

  def ==(other = nil)
    return false unless other

    key == other.key
  end

  private

  def pad(lpad, rpad, str)
    lpad + str + rpad
  end
end

class RootNode < Node
  def initialize(key, p = nil, l = nil, r = nil, height= nil)
    @key = key
    @p = p
    @l = l
    @r = r
    @height = 0
  end
end

class EmptyNode < Node
  class << self
    def from_node(node)
      self.new(nil, node, nil, nil, node.height + 1)
    end
  end

  def render(padding)
    print pad(*padding, ' * ')
  end
end

class BST
  attr_reader :max_height, :root

  def initialize(root = nil)
    @root = root
    @max_height = 0
  end

  def insert(key)
    y = nil
    x = root

    while x != nil
      y = x
      if key < x.key
        x = x.l
      else
        x = x.r
      end
    end

    if y == nil
      z = Node.new(key, nil, nil, nil, 0)
      @root = z
    else
      z = Node.new(key, y, nil, nil, y.height + 1)
      if z.key < y.key
        y.l = z
      else
        y.r = z
      end
    end

    # set tree max height
    if z.height > max_height
      @max_height = z.height
    end

    z
  end

  def insert_r(k)
    unless root
      @root = Node.new(k, nil, nil, nil, nil)
    else
      insert_r_sub(nil, root, k)
    end
  end

  def insert_r_sub(p, x, k)
    if x
      if k > x.key
        insert_r_sub(x, x.r, k)
      else
        insert_r_sub(x, x.l, k)
      end
    else
      #tail: insert the node at his postion
      z = Node.new(k, p, nil, nil, p.height + 1)
      if z.key > p.key
        p.r = z
      else
        p.l = z
      end

      # set tree max height
      if z.height > max_height
        @max_height = z.height
      end

      z
    end
  end

  def delete(z)
    if z.l == nil
      transplant(z, z.r)
    elsif z.r == nil
      transplant(z, z.l)
    else
      # here we find the succ we could also find the pred of z.l and tweak the code below to set the nodes correctly
      y = min(z.r)
      # here we check if successor is z.r and depending on that we transplant
      if y.p != z
        transplant(y,y.r)
        y.r = z.r
        y.r.p = y
      end
      transplant(z,y)
      y.l = z.l
      z.l.p = y
    end
  end

  # replace the subtree rooted at node u with
  # the subtree rooted ad the node v
  #
  #     b
  #    / \
  #   r   u
  #      / \
  #     x   v
  #        / \
  #       y   z
  #
  #      =>
  #
  #      b
  #     / \
  #    r   v
  #       / \
  #      y   z
  def transplant(u, v = nil)
    if u.p == nil
      @root = v
    elsif u.p&.l == u
      u.p.l = v
    else
      u.p.r = v if u.p&.r
    end

    v.p = u.p if v

    update_height(v, u.height)
  end

  def search(key)
    current = root

    while current && current.key != key
      current = if key < current.key
        current.l
      else
        current.r
      end
    end

    current
  end

  def min(current)
    current = current.l while current.l
    current
  end

  def max(current)
    current = current.r while current.r
    current
  end

  def successor(z)
    if z.r
      return min(z.r)
    end

    y = z.p
    x = z
    while y && y.l != x
      x = y
      y = y.p
    end

    y
  end

  def predecessor(z)
    if z.l
      return max(z.l)
    end

    y = z.p
    x = z
    while y && y.r != x
      x = y
      y = y.p
    end

    y
  end

  def pretty_print
    PrintBinaryTree.new(root, max_height, Node::KEY_SPAN, ->(node) { node.nil? }).render
  end

  def inorder_tree_walk(current)
    return unless current

    inorder_tree_walk(current.l)
    print_node(current)
    inorder_tree_walk(current.r)
  end

  def preorder_tree_walk(current)
    return unless current

    print_node(current)
    preorder_tree_walk(current.l)
    preorder_tree_walk(current.r)
  end

  def postorder_tree_walk(current)
    return unless current

    postorder_tree_walk(current.l)
    postorder_tree_walk(current.r)
    print_node(current)
  end

  def print_node(node)
    puts "#{node.key} #{ '(root)' if node.key == root.key }"
  end

  private

  def update_height(node, height)
    node.height = height
    if node.l
      update_height(node.l, height + 1)
    end
    if node.r
      update_height(node.r, height + 1)
    end
  end

  def padding(height, pad = " ")
    padding_count(height).map do |c|
      pad * c
    end
  end
end


def driver
  rbt = BST.new

  puts "Here we create a random BST:"
  keys = []
  10.times do |i|
    k = rand(100)
    next if keys.include?(k)

    keys << k
    rbt.insert(k)
    rbt.pretty_print
    readline
  end

  puts "Here we create an unbalanced BST:"
  rbt = BST.new
  (1..10).each do |i|
    rbt.insert(i)
    rbt.pretty_print
    readline
  end
end

driver

bst = BST.new(RootNode.new(25))
bst.insert(5)
bst.insert(2)
bst.insert(6)
bst.insert_r(30)
bst.insert(35)
bst.insert(15)
bst.insert(11)


puts "Horizontal tree walk:"
bst.pretty_print

# puts "Inorder tree walk:"
# bst.inorder_tree_walk(bst.root)
# puts "Preorder tree walk:"
# bst.preorder_tree_walk(bst.root)
# puts "Postorder tree walk:"
# bst.postorder_tree_walk(bst.root)

# puts "Search 35:"
# bst.print_node(bst.search(35))
# puts "Min 25:"
# bst.print_node(bst.min(bst.search(25)))
# puts "Max 25:"
# bst.print_node(bst.max(bst.search(25)))
# puts "Successor 6:"
# bst.print_node(bst.successor(bst.search(6)))
# puts "Predecessor 25:"
# bst.print_node(bst.predecessor(bst.search(25)))

# bst.pretty_print
# puts "Delete node: 25"
# bst.delete(bst.search(25))
# bst.pretty_print
