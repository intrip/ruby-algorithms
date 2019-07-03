KEY_SPAN = 3
class Node
  attr_reader :key
  attr_accessor :p, :l, :r, :depth

  def initialize(key, p, l, r, depth)
    @key = key
    @p = p
    @l = l
    @r = r
    @depth = depth
  end

  def render
    print key.to_s.ljust(KEY_SPAN)
    # TODO here need to add a x amount of spaces depending on the depth
  end

  def null_node?
    false
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

class NullNode < Node
  class << self
    def from_node(node)
      self.new(nil, node, nil, nil, node.depth + 1)
    end
  end

  def null_node?
    true
  end

  def render
    print '_'.ljust(KEY_SPAN)
  end
end

class BST
  attr_accessor :root
  attr_reader :max_depth

  def initialize(root = nil)
    @root = root
    @max_depth = 0
  end

  def insert(key)
    z = Node.new(key, nil, nil, nil, nil)
    y = nil
    x = root

    while x != nil
      y = x
      if z.key < x.key
        x = x.l
      else
        x = x.r
      end
    end

    if y == nil
      x = root
      x.depth = 0
    else
      z.p = y
      z.depth = y.depth + 1
      if z.key < y.key
        y.l = z
      else
        y.r = z
      end
    end

    # set tree max depth: used for horizontal_tree_walk
    if z.depth > max_depth
      @max_depth = z.depth
    end

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

  def successor(z)

  end

  def precedessor(z)

  end

  def horizontal_tree_walk
    path = [root]
    current_depth = 0

    print_padding(current_depth)

    while current = path.shift
      if current.depth > current_depth
        current_depth += 1
        print_depth_separator(current_depth)
        print_padding(current_depth)
      end

      current.render

      if current.l
        path.push(current.l)
      elsif current.depth < max_depth
        path.push(NullNode.from_node(current))
      end

      if current.r
        path.push(current.r)
      elsif current.depth < max_depth
        path.push(NullNode.from_node(current))
      end
    end
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
    puts "#{node.key} #{ '(root)' if node.key == root.key }"
  end

  private

  def print_padding(depth)
    pad_length = base_padding - padding_for(depth)
    pad_length = 0 if pad_length < 0

    print " " * pad_length
  end

  def base_padding
    padding_for(max_depth)
  end

  def padding_for(depth)
    # 2^depth nodes
    # each nodes uses KEY_SPAN columns
    (nodes_count(depth) * KEY_SPAN) / 2
  end

  def print_depth_separator(depth)
    print "\n"
    print_padding(depth)
    nodes_count(depth).times do |i|
      print i.even? ? ' / ' : ' \ '
    end
    print "\n"
  end

  def nodes_count(depth)
    (2 ** depth)
  end
end

bst = BST.new(RootNode.new(25))
bst.insert(5)
bst.insert(2)
bst.insert(6)
bst.insert(30)
bst.insert(35)
bst.insert(15)
bst.insert(11)
bst.root

puts "Horizontal tree walk:"
bst.horizontal_tree_walk
# puts "Inorder tree walk:"
# bst.inorder_tree_walk(bst.root)
# puts "Preorder tree walk:"
# bst.preorder_tree_walk(bst.root)
# puts "Postorder tree walk:"
# bst.postorder_tree_walk(bst.root)

# puts "\n" * 2
# puts "Search 35:"
# bst.print_node(bst.search(35))
