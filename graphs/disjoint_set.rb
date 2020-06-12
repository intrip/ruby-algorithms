# frozen_string_literal: true

SIZE = 1000
class DSU
  attr_reader :parent

  def initialize
    @parent = Array.new(SIZE) { |i| i }
  end

  def find(x)
    if parent[x] != x
      @parent[x] = find(parent[x])
    end
    @parent[x]
  end

  def union(x, y)
    xp = find(x)
    yp = find(y)
    return false if xp == yp

    @parent[xp] = yp
    true
  end
end

dsu = DSU.new
dsu.union(1,2)
dsu.union(2,3)

p dsu.union(1,3)
p dsu.union(5,3)
