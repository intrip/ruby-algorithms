require 'byebug'
require 'forwardable'
require_relative '../utils/print_binary_tree.rb'

class Node
  UNDEFINED = Object.new
  NODE_SPAN = 3

  attr_reader :key, :val, :height
  attr_accessor :left, :right

  alias :l :left
  alias :r :right

  def initialize(key, val)
    @key = key
    @val = val
    @height = 1
    @left = @right = EMPTY
  end

  # compact rapresentation of the subtree
  def dump
    has_childrens = !left.empty? || !right.empty?
    res = key.to_s
    if has_childrens
      res += "("
      res += "#{left.dump}," unless left.empty?
      res += right.dump unless right.empty?
      res += ")"
    end
    res
  end

  # used for pretty_print
  def render(padding)
    print pad(*padding, key.to_s.rjust(NODE_SPAN))
  end

  # Calls block in order
  def each(&block)
    left.each(&block) if !left.empty?
    block.call(self) if block
    right.each(&block) if !right.empty?
  end

  def empty?
    false
  end

  def insert(key, val)
    case key <=> @key
    when -1
      @left = left.insert(key, val)
    when 1
      @right = right.insert(key, val)
    when 0
      @val = val
    else
      raise "Cannot compare #{key} and #{@key} using <=>"
    end
    rotate
  end

  # @returns the [node_removed, new_root]
  def delete(key)
    case key <=> @key
    when -1
      deleted, @left = left.delete(key)
      [deleted, rotate]
    when 1
      deleted, @right = right.delete(key)
      [deleted, rotate]
    when 0
      [self, delete_self.rotate]
    else
      if empty?
        [nil, EMPTY]
      else
        raise "Cannot compare #{key} and #{@key} using <=>"
      end
    end
  end

  def get(key)
    if key == @key
      val
    elsif key > @key
      right.get(key)
    else
      left.get(key)
    end
  end

  def min
    if left.empty?
      key
    else
      left.min
    end
  end

  def max
    if right.empty?
      key
    else
      right.max
    end
  end

  def validate!
    if (left.height - right.height).abs > 1
      raise "Node #{key} is unbalanced: #{left.height} - #{height} - #{right.height}"
    end

    if [left.height, right.height].max + 1 != height
      raise "Failed to update height for #{key}: #{left.height} - #{height} - #{right.height}"
    end

    left.validate! unless left .empty?
    right.validate! unless right.empty?
  end

  protected

  # We have the following cases:
  #
  # a) T1, T2, T3 and T4 are subtrees.
  #          z                                      y
  #         / \                                   /   \
  #        y   T4      Right Rotate (z)          x      z
  #       / \          - - - - - - - - ->      /  \    /  \
  #      x   T3                               T1  T2  T3  T4
  #     / \
  #   T1   T2
  # b) Left Right Case
  #
  #      z                               z                           x
  #     / \                            /   \                        /  \
  #    y   T4  Left Rotate (y)        x    T4  Right Rotate(z)    y      z
  #   / \      - - - - - - - - ->    /  \      - - - - - - - ->  / \    / \
  # T1   x                          y    T3                    T1  T2 T3  T4
  #     / \                        / \
  #   T2   T3                    T1   T2
  # c) Right Right Case
  #
  #   z                                y
  #  /  \                            /   \
  # T1   y     Left Rotate(z)       z      x
  #     /  \   - - - - - - - ->    / \    / \
  #    T2   x                     T1  T2 T3  T4
  #        / \
  #      T3  T4
  # d) Right Left Case
  #
  #    z                            z                            x
  #   / \                          / \                          /  \
  # T1   y   Right Rotate (y)    T1   x      Left Rotate(z)   z      y
  #     / \  - - - - - - - - ->     /  \   - - - - - - - ->  / \    / \
  #    x   T4                      T2   y                  T1  T2  T3  T4
  #   / \                              /  \
  # T2   T3                           T3   T4
  #
  def rotate
    case left.height - right.height
    when 2
      if left.left.height < left.right.height # case b
        @left = left.rotate_left
      end
      root = rotate_right # case a
    when -2
      if right.right.height < right.left.height # case d
        @right = right.rotate_right
      end
      root = rotate_left # case c
    else
      root = self
    end

    root.update_height
    root
  end

  def update_height
    @height = if right.height > left.height
                right.height
              else
                left.height
              end + 1
  end

  # Rotates a node left
  #
  # For example here we rotate left 'a':
  #
  #       a                  b
  #      / \                / \
  #     c   b   - - ->     a   f
  #        / \            / \
  #       e   f          c   e
  #
  def rotate_left
    root = right
    @right = right.left
    root.left = self
    root.left.update_height
    root
  end

  # Rotates a node right
  #
  # For example here we rotate right 'b':
  #
  #       b               a
  #      / \             / \
  #     a   f   - - ->  c   b
  #    / \                 / \
  #   c   e               e   f
  #
  def rotate_right
    root = left
    @left = left.right
    root.right = self
    root.right.update_height
    root
  end

  def left=(val)
    @left = val
  end

  def right=(val)
    @right = val
  end

  # @returns [deleted, deleted.parent]
  def delete_min
    # tail: happens when we found the node to delete
    return [self, EMPTY] if left.empty?

    deleted, self.left = left.delete_min
    [deleted, self]
  end

  private

  def delete_self
    if left.empty? && right.empty?
      EMPTY
    elsif left.empty?
      right
    elsif right.empty?
      left
    else
      # Extract successor and fix the childrens
      #       50                          60
      #     /    \        delete(50)     /  \
      #    40     70        - - ->     40   70
      #          /  \                         \
      #         60   80                        80
      successor, x = right.delete_min
      if successor.key != right.key
        x.left = successor.right
        x.rotate
        successor.right = @right
      end
      successor.left = @left
      successor
    end
  end

  def pad(lpad, rpad, str)
    lpad + str + rpad
  end
end

class EmptyNode < Node
  def initialize
    @height = 0
  end

  def insert(key, val)
    Node.new(key, val)
  end

  def dump
    ''
  end

  def render(padding)
    print pad(*padding, ' * ')
  end

  def get(key)
    UNDEFINED
  end

  def empty?
    true
  end

  def rotate
    self
  end

  class << self
    def from_node(*args)
      new
    end
  end
end
EMPTY = EmptyNode.new.freeze

class AVLTree
  extend Forwardable

  attr_reader :root, :default_value

  def_delegators :@root, :dump, :validate!, :each, :min, :max

  def initialize(default_value = nil)
    @root = EmptyNode.new
    @default_value = default_value
  end

  def pretty_print
    height = root.height
    height = 0 if root.height < 0
    PrintBinaryTree.new(root, height, Node::NODE_SPAN, ->(node) { node.nil? }).render
  end

  def insert(key, val)
    @root = @root.insert(key, val)
  end
  alias :[]= :insert

  def get(key)
    res = root.get(key)
    if res == Node::UNDEFINED
      default_value
    else
      res
    end
  end
  alias :[] :get

  def delete(key)
    deleted, @root = @root.delete(key)
    deleted
  end
end

def build_tree(nodes)
  AVLTree.new.tap do |avl|
    nodes.each do |k,v|
      puts "Adding #{k},#{v}\n\n"
      avl[k] = v
      puts "dump: #{avl.dump}\n\n"
      puts "pretty print:\n\n"
      puts avl.pretty_print
      avl.validate!
      readline
    end
  end
end

puts "Here we create a random AVLTree:"
avl = build_tree([[38,1], [19,2], [41,3], [12,4], [13,5], [20,6], [21,7]])

puts "delete 12"
avl.delete(12)
puts avl.pretty_print
readline
puts "delete 20"
avl.delete(20)
puts avl.pretty_print
readline
avl.validate!
puts "#each"
avl.each do |n|
  p n.key
end
puts "min"
p avl.min
puts "max"
p avl.max

puts "Here we create an unbalanced AVLTree and let AVLTree fix that:"
avl = build_tree((1..20).zip(1..20))
puts "Done."
