=begin
  You are given a tree with n childrens, representing the members
  of a organization, you need to find the boss of all the given nodes.
  The boss is a node which is an ancestor of all the other nodes.
         F
       / |  \
     I   B    D
   / \   |  / | \
   A C   Q  G L O
           / \
          M   Z


   find_boss(D,O,M)
   =>
   D
=end

class Node
  attr_accessor :childrens
  attr_reader :name

  def initialize(name, childrens = [])
    @name = name
    @childrens = childrens
  end
end

def search_boss(*nodes)
  nodes.each do |root|
    found = {}
    nodes.map(&:name).each do |n|
      found[n] = false
    end
    dfs(root, found)
    return root if found.all? { |_, v| v }
  end
  Node.new('not found')
end

def dfs(node, found)
  if found.keys.include?(node.name)
    found[node.name] = true
  end
  # TODO optimize if found all stop

  node.childrens.each do |child|
    dfs(child, found)
  end
end


root = Node.new('F')
i = Node.new('I')
b = Node.new('B')
d = Node.new('D')
a = Node.new('A')
c = Node.new('C')
i.childrens = [a,c]
q = Node.new('Q')
b.childrens = [q]
g = Node.new('G')
l = Node.new('L')
o = Node.new('O')
m = Node.new('M')
z = Node.new('Z')
g.childrens = [m,z]
d.childrens = [g,l,o]
root.childrens = [a,b,d]

p search_boss(d, o, m).name
# => 'D'
