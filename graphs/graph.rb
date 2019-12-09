#!/usr/bin/env ruby
# frozen_string_literal: true

# This is a graph implemented using ajacency-list.
# We assume vertex indexes are unque.
class Graph
  attr_accessor :vertices, :adj

  def initialize(vertices = [])
    @vertices = vertices
    @adj = Array.new(vertices.length) { [] }
  end

  def add_edge(from, to)
    adj[vertices.index(from)] << to
  end

  def dump
    vertices.each_with_index.inject('') do |str, (v, i)|
      str + "#{v.id}(#{adj[i].map(&:to_s).join(',')})\n"
    end
  end
end

class Vertex
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def to_s
    id
  end
end

# Creates the following graph:
#
#      (1) --➡️  (2) --➡️  (3)
#                |        |
#                |        |
#               ⬇️        ⬇️ 
#               (4) --➡️  (5) --➡️  (6)
#
def build_graph
  v1 = Vertex.new(1)
  v2 = Vertex.new(2)
  v3 = Vertex.new(3)
  v4 = Vertex.new(4)
  v5 = Vertex.new(5)
  v6 = Vertex.new(6)
  g = Graph.new([v1, v2, v3, v4, v5, v6])
  g.add_edge(v1, v2)
  g.add_edge(v2, v3)
  g.add_edge(v2, v4)
  g.add_edge(v3, v5)
  g.add_edge(v4, v5)
  g.add_edge(v5, v6)

  g
end

# g = build_graph
# puts g.dump
