# BST is a Binary search tree
#
# The tree has the following property: for every node his left node are <= then the parent and
# the parent is <= than his right node.
# This property allows to do all the important operation in O(h) == log(n) (if the tree is balanced)
#
class Node
  KEY_SPAN = 3

  attr_reader :key
  attr_accessor :p, :l, :r, :depth

  def initialize(key, p, l, r, depth)
    @key = key
    @p = p
    @l = l
    @r = r
    @depth = depth
  end

  def render(padding)
    print pad(*padding, key.to_s.rjust(Node::KEY_SPAN))
  end

  def null_node?
    false
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
  def initialize(key, p = nil, l = nil, r = nil, depth= nil)
    @key = key
    @p = p
    @l = l
    @r = r
    @depth = 0
  end
end

class EmptyNode < Node
  class << self
    def from_node(node)
      self.new(nil, node, nil, nil, node.depth + 1)
    end
  end

  def null_node?
    true
  end

  def render(padding)
    print pad(*padding, ' * ')
  end
end

class BST
  attr_reader :max_depth, :root

  def initialize(root = nil)
    @root = root
    @max_depth = 0
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
      z = Node.new(key, y, nil, nil, y.depth + 1)
      if z.key < y.key
        y.l = z
      else
        y.r = z
      end
    end

    # set tree max depth
    if z.depth > max_depth
      @max_depth = z.depth
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
      z = Node.new(k, p, nil, nil, p.depth + 1)
      if z.key > p.key
        p.r = z
      else
        p.l = z
      end

      # set tree max depth
      if z.depth > max_depth
        @max_depth = z.depth
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

    update_depth(v, u.depth)
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

  def horizontal_tree_walk
    path = [root]
    current_depth = 0

    while current = path.shift
      # depth increased: we print the / \ separator
      if current.depth > current_depth
        current_depth += 1
        print_depth_separator(current_depth)
      end

      current.render(padding(current.depth))

      if current.l
        path.push(current.l)
      elsif current.depth < max_depth
        path.push(EmptyNode.from_node(current))
      end

      if current.r
        path.push(current.r)
      elsif current.depth < max_depth
        path.push(EmptyNode.from_node(current))
      end
    end

    puts "\n"
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

  def update_depth(node, depth)
    node.depth = depth
    if node.l
      update_depth(node.l, depth + 1)
    end
    if node.r
      update_depth(node.r, depth + 1)
    end
  end

  def padding(depth, pad = " ")
    padding_count(depth).map do |c|
      pad * c
    end
  end

  def padding_count(depth)
    # total space occupied by nodes / total nodes / 2
    padding = (max_span - span_for(depth)) / nodes_count(depth)
    rem = padding % 2
    lpad = padding / 2
    # we add the rounding reminder to the right node if present
    rpad = rem.zero? ? lpad : lpad + rem
    [lpad, rpad]
  end

  def print_depth_separator(depth)
    print "\n"
    nodes_count(depth).times do |i|
      print padding(depth).first
      print i.even? ? ' / ' : ' \ '
      print padding(depth).last
    end
    print "\n"
  end

  def max_span
    span_for(max_depth)
  end

  def span_for(depth)
    Node::KEY_SPAN * nodes_count(depth)
  end

  def nodes_count(depth)
    (2 ** depth)
  end
end


def driver
  rbt = BST.new

  puts "Here we create a random tree:"
  keys = []
  10.times do |i|
    k = rand(100)
    next if keys.include?(k)

    keys << k
    rbt.insert(k)
    rbt.horizontal_tree_walk
    readline
  end

  puts "Here we create an unbalanced tree:"
  rbt = BST.new
  (1..6).each do |i|
    rbt.insert(i)
    rbt.horizontal_tree_walk
    readline
  end
end

# driver

# bst = BST.new(RootNode.new(25))
# bst.insert(5)
# bst.insert(2)
# bst.insert(6)
# bst.insert_r(30)
# bst.insert(35)
# bst.insert(15)
# bst.insert(11)


# puts "Horizontal tree walk:"
# bst.horizontal_tree_walk

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

# bst.horizontal_tree_walk
# puts "Delete node: 25"
# bst.delete(bst.search(25))
# bst.horizontal_tree_walk
