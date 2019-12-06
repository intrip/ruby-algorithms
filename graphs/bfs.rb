#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './graph.rb'

INF = Float::INFINITY
class Graph
  def bfs(start)
    vertices.each do |v|
      v.c = 'w'
      v.dst = INF
      v.prev = nil
    end
    start.dst = 0
    queue = [start]

    while u = queue.shift
      adj[vertices.index(u)].each do |v|
        next if v.c == 'b'
        v.dst = u.dst + 1
        v.prev = u
        queue.push(v)
      end
      u.c = 'b'
    end
  end
end

class Vertex
  COLORS = %w(w b)
  attr_reader :id
  attr_accessor :c, :dst, :prev

  def initialize(id)
    @id = id
  end

  def inspect
    "#{id}@#{dst}".then { |s| prev ? s + "<#{prev.id}" : s }
  end
end

g = build_graph
g.bfs(g.vertices[0])
g.vertices.each do |v|
  p v
end
