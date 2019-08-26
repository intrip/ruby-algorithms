# Prints a binary tree
class PrintBinaryTree
  attr_reader :root, :max_height, :nil_node, :empty_node_class, :nil_node_proc

  # A Node needs to respond to: :height, :render
  # Node needs also to have a KEY_SPAN constant
  def initialize(root, max_height, nil_node, empty_node_class, nil_node_proc)
    @root = root
    @max_height = max_height
    @nil_node = nil_node
    @empty_node_class = empty_node_class
    @nil_node_proc = nil_node_proc
  end

  # pretty prints the tree:
  #
  #           41
  #     /           \
  #     19          *
  #  /     \     /     \
  #  12    31    *     *
  # /  \  /  \  /  \  /  \
  #  8 *  *  *  *  *  *  *
  #
  def render
    path = [root]
    current_height = 0

    while current = path.shift
      next if nil_node_proc.call(current)

      # height increased: we print the / \ separator
      if current.height > current_height
        current_height += 1
        print_height_separator(current_height)
      end

      current.render(padding(current.height))

      # navigate left
      if !nil_node_proc.call(current.l)
        path.push(current.l)
      elsif current.height < max_height
        path.push(EmptyNode.from_node(current, nil_node))
      end

      # navigate right
      if !nil_node_proc.call(current.r)
        path.push(current.r)
      elsif current.height < max_height
        path.push(EmptyNode.from_node(current, nil_node))
      end
    end
    puts "\n\n"
  end

  private

  def max_span
    span_for(max_height)
  end

  def span_for(height)
    root.class::KEY_SPAN * nodes_count(height)
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
    # add the rounding reminder to the right node if present
    rpad = rem.zero? ? lpad : lpad + rem

    [lpad, rpad]
  end
end
