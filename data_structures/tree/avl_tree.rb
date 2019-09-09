require_relative '../utils/print_binary_tree.rb'
require 'byebug'

class Node
  KEY_SPAN = 3

  attr_reader :key
  attr_accessor :p, :l, :r, :b, :height

  def initialize(key:, p: nil, l: nil, r: nil, b: 0, height: 0)
    @key = key
    @p = p
    @l = l
    @r = r
    @b = b
    @height = height
  end

  def render(padding)
    print pad(*padding, "#{key}_#{b}@#{height}")
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

class EmptyNode < Node
  class << self
    def from_node(node, nil_node)
      self.new(key: nil, p: node, height: node.height + 1)
    end
  end

  def render(padding)
    print pad(*padding, ' * ')
  end
end

class AVLTree
  attr_reader :max_height, :root, :debug

  def initialize(root = nil, debug = false)
    @root = root
    @max_height = 0
    @debug = debug
  end

  def insert(key)
    y = nil
    x = root

    while !x.nil?
      y = x
      if key < x.key
        x.b -= 1
        x = x.l
      else
        x.b += 1
        x = x.r
      end
    end

    if y.nil?
      @root = z = Node.new(key: key)
    else
      z = Node.new(key: key, p: y, height: y.height + 1)
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

    avl_fixup(z)

    z
  end

  def horizontal_tree_walk
    PrintBinaryTree.new(root, max_height, nil, EmptyNode, ->(node) { node.nil? }).render
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

    puts_debug "Rotate L: #{z.key}"

    y_new_height = z.height
    # reduce tree_height to force recaulculation if rotation could reduce the tree_height
    # if z.height == (max_height - 2)
    #   @max_height = z.height
    # end

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
    y.l.p = z if !y.l.nil?

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

    puts_debug "Rotate R: #{z.key}"

    y_new_height = z.height
    # reduce tree_height to force recaulculation if rotation could reduce the tree_height
    # if z.height == (max_height - 2)
    #   @max_height = z.height
    # end

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
    y.r.p = z if y.r

    # set y.r
    y.r = z
    z.p = y

    update_height(y, y_new_height)

    z
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

  def avl_fixup(z)
    grandparent = z.p&.p
    return if !grandparent
    return if grandparent.b < 2 && grandparent.b > -2

    parent = z.p

    if parent == grandparent.l
      if z == parent.r
        # makes z parent.l
        z.p = parent.p
        grandparent.l = z
        z.l = parent
        parent.p = z
        parent.r = nil

        z = parent
        parent = z.p
        update_height(parent, z.height)
      end

      # TODO fix balance values here but also on rotations at first
      # also reduce tree max height on rotation (fix commented code)
      rotate_r(grandparent)
    else
      # z needs to be parent.r

    end
  end

  def puts_debug(txt)
    puts txt if debug
  end
end

avl = AVLTree.new(nil, true)
[38, 19, 41, 12, 13].each do |i|
  avl.insert(i)
  avl.horizontal_tree_walk
  readline
end

# avl.rotate_r(avl.search(19))
# TODO
# implement the balance and rotation
# recalculate balance and height after rotation too
