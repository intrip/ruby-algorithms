# This tree can have n childrens

Node = Struct.new(:left_c, :right_s, :key)

class Tree
  attr_reader :root

  def initialize(root)
    @root = root
  end

  def add_child(node, key)
    node.left_c = Node.new(nil, nil, key)
  end

  def add_sibling(node, key)
    node.right_s = Node.new(nil, nil, key)
  end

  def to_s
    collect_nodes
      .map(&method(:print_node))
      .join
  end

  private

  def collect_nodes
    nodes = [root]
    stack = nodes.clone

    while current = stack.pop
      if left = current.left_c
        nodes << left
        stack << left
      end

      if right = current.right_s
        nodes << right
        stack << right
      end
    end

    nodes
  end

  def print_node(node)
    res = "Node: #{node.key}"
    res << '(root)' if node.key == root.key
    res << "\n"
  end
end

root = Node.new(nil, nil, 'root')
tree = Tree.new(root)
b = tree.add_child(root, 'b')
c = tree.add_sibling(b, 'c')
tree.add_sibling(c, 'd')
tree.add_child(c, 'e')

puts tree
