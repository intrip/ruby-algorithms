require 'readline'
require 'byebug'

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

# the width of each printed node key
KEY_SPAN = 3
class Node
  attr_reader :key
  attr_accessor :p, :l, :r, :c, :height

  def initialize(key, p, l, r, c, height)
    @key = key
    @p = p
    @l = l
    @r = r
    @c = c
    @height = height
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
    "#{key}@#{c}:#{p&.key},#{l&.key},#{r&.key};#{height}."
  end

  private

  def key_s
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

# Every leaf node is a nil node in a RBTree, also the root.p
class NilNode < Node
  def initialize(*args)
    super(nil, nil, nil, nil, nil, nil)
  end

  def nil_node?
    true
  end

  # nil nodes are always black
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
      self.new(nil, node, nil_node, nil_node, '', node.height + 1)
    end
  end

  def render(padding)
    print pad(*padding, ' * '.colorize(LIGHT_GRAY))
  end
end

class RBTree
  attr_reader :root, :nil_node
  attr_accessor :tree_height
  attr_reader :debug

  def initialize(root = nil, debug = false)
    @nil_node = NilNode.new
    if root
      @root = root
      @root.p = nil_node
    end
    @tree_height = 0
    @nodes_count = 0
    @highest_leafs = []
    @debug = debug
  end

  # insert a node with key in the tree
  def insert(key)
    y = nil_node
    x = root

    puts_debug "Insert #{key}"

    # find node parent
    while x && !x.nil_node?
      y = x
      if key < x.key
        x = x.l
      else
        x = x.r
      end
    end

    # create node and set parent
    if y.nil_node?
      z = Node.new(key, nil_node, nil_node, nil_node, 'r', 0)
      @root = z
    else
      z = Node.new(key, y, nil_node, nil_node, 'r', y.height + 1)
      if z.key < y.key
        y.l = z
      else
        y.r = z
      end
    end

    insert_fixup(z)
    @nodes_count += 1
    if z.height == tree_height
      @highest_leafs << z
    end
    update_tree_height(z)

    z
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

    puts_debug "Rotate L: #{z.as_str}"

    y_new_height = z.height
    # reduce tree_height to force recaulculation if rotation could reduce the tree_height
    if z.height == (tree_height - 2)
      puts_debug "Reduce height to #{z.height}"
      @tree_height = z.height
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

    update_height(y, y_new_height)

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

    puts_debug "Rotate R: #{z.as_str}"

    y_new_height = z.height
    # reduce tree_height to force recaulculation if rotation could reduce the tree_height
    if z.height == (tree_height - 2)
      puts "Reduce height to #{z.height}"
      @tree_height = z.height
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

    update_height(y, y_new_height)

    z
  end

  # Removes a node from the tree
  def delete(z)
    y = z
    y_original_c = z.c

    if z.l.nil_node?
      x = z.r
      transplant(z, z.r)
    elsif z.r.nil_node?
      x = z.l
      transplant(z, z.l)
    else
      y = min(z.r)
      y_original_c = y.c
      x = y.r
      if y.p == z
        x.p = y
      else
        transplant(y, y.r)
        y.r = z.r
        y.r.p = y
      end
      transplant(z, y)
      y.l = z.l
      y.l.p = y
      y.c = z.c
    end

    if y_original_c == 'b'
      delete_fixup(x)
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
  def transplant(u,v)
    if @root == u
      @root = v
    elsif u == u.p.l
      u.p.l = v
    elsif u == u.p.r
      u.p.r = v
    end

    v.p = u.p

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
    current = current.l while !current.l.nil_node?
    current
  end

  def max(current)
    current = current.r while !current.r.nil_node?
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

  # pretty prints the tree
  def horizontal_tree_walk
    path = [root]
    current_height = 0

    while current = path.shift
      next if current.nil_node?

      # height increased: we print the / \ separator
      if current.height > current_height
        current_height += 1
        print_height_separator(current_height)
      end

      current.render(padding(current.height))

      if !current.l.nil_node?
        path.push(current.l)
      elsif current.height < tree_height
        path.push(EmptyNode.from_node(current, nil_node))
      end

      if !current.r.nil_node?
        path.push(current.r)
      elsif current.height < tree_height
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
    preorder_tree_walk(current.l)
    preorder_tree_walk(current.r)
  end

  def postorder_tree_walk(current)
    return unless current

    postorder_tree_walk(current.l)
    postorder_tree_walk(current.r)
    print_node(current)
  end

  def balance_info
    max_height =(2 * Math.log(@nodes_count + 1, 2)).round
    puts "Total nodes: #{@nodes_count}, Height: #{tree_height}, Max Height: #{max_height}, Balanced? #{max_height >= tree_height}"
  end

  private

  # fix the red black violations: either rule 4 or 2
  def insert_fixup(z)
    while z.p&.c == 'r'
      if z.p == z.p.p.l
        y = z.p.p.r
        # case 1: uncle red
        if y.c == 'r'
          z.p.c = 'b'
          y.c = 'b'
          z.p.p.c = 'r'
          z = z.p.p
        else
          # case2: uncle black and right child
          if z == z.p.r
            z = z.p
            rotate_l(z)
          end

          # case3: uncle black and left child
          z.p.c = 'b'
          z.p.p.c = 'r'
          rotate_r(z.p.p)
        end
      # same as the if with l and r swapped
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

    # root is always black to fix rule 2
    root.c = 'b'
  end

  # fix the red balack violations (rules 1, 2, 4) after node deletion by moving the double black up to the
  # tree until we reach the root
  def delete_fixup(x)
    byebug
    while x != @root && x.c == 'b'
      if x == x.p.l
        w = x.p.r
        if w.c == 'r'
          w.c = 'b'
          w.p.c = 'r'
          rotate_l(x.p)
          w = x.p.r
        end
        # @dup
        if w.l.c == 'b' && w.r.c == 'b'
          w.c = 'r'
          x = x.p
        elsif w.r.c = 'b'
          w.l.c = 'b'
          w.c = 'r'
          rotate_r(w)
          w = x.p.r
        end
        w.c = x.p.c
        x.p.c = 'b'
        w.r.c = 'b'
        rotate_l(x.p)
        x = @root # to stop the loop
      else
        w = x.p.l
        if w.c = 'r'
          w.c = 'b'
          w.p.c = 'r'
          rotate_r(x.p)
          x = x.p.l
        end
        # @dup
        if w.l.c == 'b' && w.r.c == 'b'
          w.c = 'r'
          x = x.p
        elsif w.l.c == 'b'
          w.r.c = 'b'
          w.c = 'r'
          rotate_l(w)
          w = x.p.l
        end
        w.c = x.p.c
        w.p.c = 'b'
        w.l.c = 'b'
        rotate_r(x.p)
        x = @root # to stop the loop
      end

    end
    x.c = 'b'
  end

  def print_node(node)
    puts "#{node.as_str} #{ '(root)' if node.key == root.key }"
  end

  def puts_debug(txt)
    puts txt if debug
  end

  # updates a node and his childrens height; also recalculates tree_height
  def update_height(node, height)
    puts_debug "Update height, #{node.as_str} dept: #{height}"

    node.height = height

    update_tree_height(node)

    if node.l && !node.l.nil_node?
      update_height(node.l, height + 1)
    end
    if node.r && !node.r.nil_node?
      update_height(node.r, height + 1)
    end
  end

  def update_tree_height(node)
    @tree_height = @highest_leafs.map(&:height).max
    if node.height > tree_height
      puts_debug "Increased tree height to #{node.height}"

      @highest_leafs = [node]
      @tree_height = node.height
    end
  end

  def padding(height, pad = " ")
    paddings(height).map do |c|
      pad * c
    end
  end

  def paddings(height)
    # total space occupied by nodes / total nodes
    padding = (max_span - span_for(height)) / nodes_count(height)

    rem = padding % 2
    lpad = padding / 2
    # we add the rounding reminder to the right node if present
    rpad = rem.zero? ? lpad : lpad + rem

    [lpad, rpad]
  end

  def max_span
    span_for(tree_height)
  end

  def span_for(height)
    KEY_SPAN * nodes_count(height)
  end

  def nodes_count(height)
    (2 ** height)
  end

  def print_height_separator(height)
    print "\n"
    nodes_count(height).times do |i|
      print padding(height).first
      print i.even? ? ' / ' : ' \ '
      print padding(height).last
    end
    print "\n"
  end
end

rbt = RBTree.new
# keys = []
# [3,2,1,4,7,8,9,13,22].each do |i|
[41, 38, 31, 12, 19, 8].each do |i|
# 5.times do |i|
  # k = rand(100)
  # if keys.include?(k)
  #   next
  # end
  # keys << k
  # rbt.insert(k)
  rbt.insert(i)
  # puts rbt.balance_info
  # rbt.horizontal_tree_walk
end

# TODO fix delete_fixup when deleting the root, this happens because x is a nil node...

# Manual tests:
rbt.horizontal_tree_walk
rbt.delete(rbt.search(38))
rbt.horizontal_tree_walk
puts rbt.balance_info
# puts "transplant 19 => 31"
# rbt.transplant(rbt.search(19), rbt.search(31))
# rbt.horizontal_tree_walk
# puts rbt.balance_info
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
# rbt.preorder_tree_walk(rbt.root)
# puts "Postorder tree walk:"
# rbt.postorder_tree_walk(rbt.root)
