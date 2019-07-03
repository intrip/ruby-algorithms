Node = Struct.new(:left, :right, :key)

class BTree
  attr_reader :root

  def initialize(root)
    @root = root
  end

  def add_child(parent, pos, key)
    new_node = Node.new(nil, nil, key)

    if pos == 'l'
      parent.left = new_node
    else
      parent.right = new_node
    end

    new_node
  end

  def to_s_horizontal
    str = ''
    path = [root]

    while(path.any?)
      node = path.shift

      str << print_node(node)

      if node.left
        path << node.left
      end

      if node.right
        path << node.right
      end
    end

    str
  end

  # iterative inorder tree walk
  def to_s_inorder
    str = ''
    stack = [root]
    node = root

    navigate_left(node, stack)

    while stack.any?
      node = stack.pop
      str << print_node(node)

      if node.right
        stack.push(node.right)
        navigate_left(node.right, stack)
      end
    end

    str
  end

  # iterative inorder tree walk 2
  def to_s_inorder_2
    str = ''
    current = root
    stack = []
    done = false

    until done
      if current
        stack.push(current)
        current = current.left
      else
        if stack.any?
          current = stack.pop
          str << print_node(current)
          current = current.right
        else
          done = true
        end
      end
    end

    str
  end

  private

  def print_node(node)
    res = "Node: #{node.key}"
    res << "(root)" if node.key == root.key
    res << "\n"

    res
  end

  def navigate_left(current, stack)
    while current = current.left
      stack.push(current)
    end
  end
end

root = Node.new(nil, nil, 25)
tree = BTree.new(root)
n15 = tree.add_child(root, 'l', 15)
n10 = tree.add_child(n15, 'l', 10)
n22 = tree.add_child(n15, 'r', 22)
n50 = tree.add_child(root, 'r', 50)
n35 = tree.add_child(n50, 'l', 35)
n70 = tree.add_child(n50, 'r', 70)
n4 = tree.add_child(n10, 'l', 4)
n12 = tree.add_child(n10, 'r', 12)
n18 = tree.add_child(n22, 'l', 18)
n24 = tree.add_child(n22, 'r', 24)
n31 = tree.add_child(n35, 'l', 31)
n44 = tree.add_child(n35, 'r', 44)
n66 = tree.add_child(n70, 'l', 66)
n90 = tree.add_child(n70, 'r', 90)

puts "inorder tree walk iterative 1: "
puts tree.to_s_inorder

print "\n\n"

puts "inorder tree walk iterative 2: "
puts tree.to_s_inorder_2

print "\n\n"

puts "horizontal tree walk iterative: "
puts tree.to_s_horizontal
