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

  def render(padding)
    print pad(*padding, key.to_s.rjust(KEY_SPAN))
  end

  def null_node?
    false
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

class NullNode < Node
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

  def delete(z)
    if z.l == nil
      transplant(z, z.r)
    elsif z.r == nil
      transplant(z, z.l)
    else
      # here we check if successor is z.r and depending on that we transplant
      succ = successor(z)
      if succ.key != z.r
        # TODO need to swap succ with z.r and fix the tree
      end
      transplant(z,z.r)
      z.r.l = z.l
      z.l.p = z.r
    end
  end

  # replace the subtree rooted at node u with
  # the subtree rooted ad the node v
  def transplant(u,v = nil)
    self.root = v if u.p == nil

    v.depth = u.depth if v

    if u.p.l&.key == u.key
      u.p.l = v
    else
      u.p.r = v
    end

    v.p = u.p if v
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
    while y && y.l.key != x.key
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
    while y && y.r.key != x.key
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
        path.push(NullNode.from_node(current))
      end

      if current.r
        path.push(current.r)
      elsif current.depth < max_depth
        path.push(NullNode.from_node(current))
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
    puts "#{node.key} #{ '(root)' if node.key == root.key }"
  end

  private

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
# puts "Min 25:"
# bst.print_node(bst.min(bst.search(25)))
# puts "Max 25:"
# bst.print_node(bst.max(bst.search(25)))
# puts "Successor 6:"
# bst.print_node(bst.successor(bst.search(6)))
# puts "Predecessor 25:"
# bst.print_node(bst.predecessor(bst.search(25)))
puts "Delete node: 15"
bst.delete(bst.search(15))
bst.horizontal_tree_walk
