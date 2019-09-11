require 'byebug'
require 'forwardable'

class Node
  UNDEFINED = Object.new

  attr_reader :key, :val, :height
  attr_accessor :left, :right

  def initialize(key, val)
    @key = key
    @val = val
    @height = 1
    @left = @right = EMPTY
  end

  def dump
    has_childrens = !left.empty? || !right.empty?
    res = key.to_s
    if has_childrens
      res += "("
      res += "#{left.dump}," unless left.empty?
      res += "#{right.dump}" unless right.empty?
      res += ")"
    end
    res
  end

  def empty?
    false
  end

  def insert(new_key, val)
    case new_key <=> key
    when -1
      @left = left.insert(new_key, val)
    when 1
      @right = right.insert(new_key, val)
    when 0
      @val = val
    else
      raise "Cannot compare #{new_key} and #{key} using <=>"
    end
    rotate
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

  def rotate
    case left.height - right.height
    when 2
      if left.left.height < left.right.height
        @left = left.rotate_left
      end
      root = rotate_right
    when -2
      if right.right.height < right.left.height
        @right = right.rotate_right
      end
      root = rotate_left
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
  #     c   b     =>       a   f
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
  #     a   f     =>    c   b
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

  def get(key)
    UNDEFINED
  end

  def empty?
    true
  end

  def rotate
    self
  end
end
EMPTY = EmptyNode.new.freeze

class AVLTree
  extend Forwardable

  attr_reader :root, :default_value

  def_delegators :@root, :dump, :validate!

  def initialize(default_value = nil)
    @root = EmptyNode.new
    @default_value = default_value
  end

  def insert(key, val)
    @root = @root.insert(key, val)
  end

  def get(key)
    res = root.get(key)
    if res == Node::UNDEFINED
      default_value
    else
      res
    end
  end
  alias :[] :get
end

avl = AVLTree.new
[[38,1], [19,2], [41,3], [12,4], [13,5], [20,6], [21,7]].each do |k,v|
  avl.insert(k, v)
  puts avl.dump
  avl.validate!
  readline
end

p avl[99]
# Add doc for rotate
# Implement delete and the tree walks
