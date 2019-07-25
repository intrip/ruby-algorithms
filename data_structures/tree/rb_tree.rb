require 'byebug'
require 'readline'

# Red back tree
# Is an extended BST. A RB tree node in fact has the property color (c)
# which can be ether red (r) or black (b).
#
# Also RB tree need to respect the following rules (including the BST rules):
#
# 1. A node can be either red or black
# 2. The root is black
# 3. all the nil leafs are black
# 4. If x is red both his childrens needs to be black
# 5. for each node x all the simple path to the leafs should have the same n° of
#    black nodes
#
# RB tree has the important property that guarantees that their height is <= 2log(n+1)
# thus all the tree operatins can run in O(lgn).

# Adds color to Str class: not optimal to monkey patch ruby core classes but for this purpose it's allright :-)
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

KEY_SPAN = 3
class Node
  attr_reader :key
  attr_accessor :p, :l, :r, :c, :depth

  def initialize(key, p, l, r, c, depth)
    @key = key
    @p = p
    @l = l
    @r = r
    @c = c
    @depth = depth
  end

  def render(padding)
    print pad(*padding, as_str_padded)
  end

  def as_str_padded
    key_s.rjust(KEY_SPAN).colorize(color)
  end

  def as_str
    key_s.colorize(color)
  end

  def nil_node?
    false
  end

  def ==(other = nil)
    return false unless other

    key == other.key
  end

  def inspect
    "#{key}@#{c}:#{p&.key},#{l&.key},#{r&.key};#{depth}"
  end

  private

  def key_s
    # debuggin info
    # key.to_s + ".#{depth}"
    key.to_s
  end

  def color
    # red is 31, 1 is black bold
    (c == 'r') ? 31 : 1
  end

  def pad(lpad, rpad, str)
    lpad + str + rpad
  end
end

class RootNode < Node
  def initialize(key, p = nil, l = nil, r = nil, c = nil, depth= nil)
    @key = key
    @p = p
    @l = l
    @r = r
    @c = c
    @depth = 0
  end
end

# Every leaf node is nil node
class NilNode < Node
  def initialize(*args)
    super(nil, nil, nil, nil, nil, nil)
  end

  def nil_node?
    true
  end

  def c
    'b'
  end

  def render
    # we do not render nil nodes for the sake of simplicty
  end
end

class EmptyNode < Node
  LIGHT_GRAY = 2

  class << self
    def from_node(node, nil_node)
      # empty node has no color
      self.new(nil, node, nil_node, nil_node, '', node.depth + 1)
    end
  end

  def render(padding)
    print pad(*padding, ' * '.colorize(LIGHT_GRAY))
  end
end

class RBTree
  attr_reader :root, :nil_node
  attr_accessor :max_depth

  def initialize(root = nil)
    if root
      @root = root
      @root.p = nil_node
    end
    @nil_node = NilNode.new
    @max_depth = 0
    @nodes_count = 0
  end

  def insert(key)
    y = nil_node
    x = root

    while x && !x.nil_node?
      y = x
      if key < x.key
        x = x.l
      else
        x = x.r
      end
    end

    if y.nil_node?
      z = Node.new(key, nil_node, nil_node, nil_node, 'r', 0)
      @root = z
    else
      z = Node.new(key, y, nil_node, nil_node, 'r', y.depth + 1)
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

    rb_insert_fixup(z)
    @nodes_count += 1
    z
  end

  def rb_insert_fixup(z)
    while z.p&.c == 'r'
      if z.p == z.p.p.l
        y = z.p.p.r
        if y.c == 'r'
          z.p.c = 'b'
          y.c = 'b'
          z.p.p.c = 'r'
          z = z.p.p
        else
          if z == z.p.r
            z = z.p
            rotate_l(z)
          end

          z.p.c = 'b'
          z.p.p.c = 'r'
          rotate_r(z.p.p)
        end
      else
        y = z.p.p.l
        if y.c == 'r'
          z.p.c = 'b'
          y.c = 'b'
          z.p.p.c = 'r'
          z = z.p.p
        else
          if z == z.p.l
            z = z.p
            rotate_r(z)
          end

          z.p.c = 'b'
          z.p.p.c = 'r'
          rotate_l(z.p.p)
        end
      end
    end

    root.c = 'b'
  end

  # rotates a node left
  #
  # for example here we
  # rotate left 'a':
  #
  #       a
  #      / \
  #     c   b
  #        / \
  #       e   f
  #
  #     =>
  #
  #       b
  #      / \
  #     a   f
  #    / \
  #   c   e
  #
  def rotate_l(z)
    y = z.r

    return false unless y

    y_new_depth = z.depth
    # reduce max_depth to force recaulculation when rotations would reduce the
    # tree height
    if z.r.depth == ((max_depth - 1) || max_depth)
      @max_depth = z.depth
    end

    # set parent of y
    y.p = z.p
    if z == root
      @root = y
    elsif z == z.p.l
      z.p.l = y
    else
      z.p.r = y
    end

    # set z.r to y.l
    z.r = y.l
    y.l.p = z if !y.l.nil_node?

    # set y.l
    y.l = z
    z.p = y

    update_depth(y, y_new_depth)

    z
  end

  # rotates a node right
  #
  # for example here we
  # rotate right 'b':
  #
  #       b
  #      / \
  #     a   f
  #    / \
  #   c   e
  #
  #     =>
  #
  #       a
  #      / \
  #     c   b
  #        / \
  #       e   f
  #
  def rotate_r(z)
    y = z.l

    return false unless y

    y_new_depth = z.depth
    # reduce max_depth to force recaulculation when rotations would reduce the
    # tree height
    if z.l.depth == ((max_depth - 1) || max_depth)
      @max_depth = z.depth
    end


    # set parent of y
    y.p = z.p
    if z == root
      @root = y
    elsif z.p.l == z
      z.p.l = y
    else
      z.p.r = y
    end

    # set z.l to y.r
    z.l = y.r
    y.r.p = z if !y.r.nil_node?

    # set y.r
    y.r = z
    z.p = y

    update_depth(y, y_new_depth)

    z
  end

  # def delete(z)
  #   if z.l == nil
  #     transplant(z, z.r)
  #   elsif z.r == nil
  #     transplant(z, z.l)
  #   else
  #     # here we find the succ we could also find the pred of z.l and tweak the code below to set the nodes correctly
  #     y = min(z.r)
  #     # here we check if successor is z.r and depending on that we transplant
  #     if y.p != z
  #       transplant(y,y.r)
  #       y.r = z.r
  #       y.r.p = y
  #     end
  #     transplant(z,y)
  #     y.l = z.l
  #     z.l.p = y
  #   end
  # end

  # replace the subtree rooted at node u with
  # the subtree rooted ad the node v
  # def transplant(u, v = nil)
  #   @root = v if u.p == nil

  #   update_depth(v, u.depth)

  #   if u.p&.l == u
  #     u.p.l = v
  #   else
  #     u.p.r = v if u.p&.r
  #   end

  #   v.p = u.p if v
  # end

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
      next if current.nil_node?

      # depth increased: we print the / \ separator
      if current.depth > current_depth
        current_depth += 1
        print_depth_separator(current_depth)
      end

      current.render(padding(current.depth))

      if current.l && !current.l.nil_node?
        path.push(current.l)
      elsif current.depth < max_depth
        path.push(EmptyNode.from_node(current, nil_node))
      end

      if current.r && !current.r.nil_node?
        path.push(current.r)
      elsif current.depth < max_depth
        path.push(EmptyNode.from_node(current, nil_node))
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
    inorder_tree_walk(current.l)
    inorder_tree_walk(current.r)
  end

  def postorder_tree_walk(current)
    return unless current

    inorder_tree_walk(current.l)
    inorder_tree_walk(current.r)
    print_node(current)
  end

  def print_node(node)
    puts "#{node.as_str} #{ '(root)' if node.key == root.key }"
  end

  def balance_info
    max_height =(2 * Math.log(@nodes_count + 1,2)).round
    puts "Total nodes: #{@nodes_count}, Height: #{max_depth}, Max Height: #{max_height}, Balanced? #{max_height >= max_depth}"
  end

  private

  # updates a node and his childrens depth
  def update_depth(node, depth)
    node.depth = depth

    # keep max_depth up to date
    if depth > max_depth
      @max_depth = depth
    end

    if node.l && !node.l.nil_node?
      update_depth(node.l, depth + 1)
    end
    if node.r && !node.r.nil_node?
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
    KEY_SPAN * nodes_count(depth)
  end

  def nodes_count(depth)
    (2 ** depth)
  end
end

rbt = RBTree.new
25.times do |i|
  rbt.insert(rand(100))
  # rbt.insert(i)
  puts "\nTree:\n"
  rbt.horizontal_tree_walk
  puts rbt.balance_info
  # readline
end


rbt.insert(1)
rbt.insert(2)
rbt.insert(3)

# TODO go from here
# fix the rotation depth update because decrease too much
# do the delete

rbt.horizontal_tree_walk
puts rbt.max_depth
# puts "\n"
# puts "left rotate root (25)"
# rbt.rotate_l(rbt.root)
# rbt.horizontal_tree_walk
# puts "right rotate (30)"
# rbt.rotate_r(rbt.search(30))
# rbt.horizontal_tree_walk
# puts "right rotate (25)"
# rbt.rotate_r(rbt.search(25))
# rbt.horizontal_tree_walk
# puts "\nInorder tree walk:"
# rbt.inorder_tree_walk(rbt.root)
# puts "Preorder tree walk:"
# bst.preorder_tree_walk(bst.root)
# puts "Postorder tree walk:"
# bst.postorder_tree_walk(bst.root)
