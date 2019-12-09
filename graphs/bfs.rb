#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './graph.rb'

# BFS computes the distance of every verext from a given vertex.
# The time complexity is O(V + E).
class Graph
  INF = Float::INFINITY

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

  # prints all the path from a vertex back to v
  def print_path(u, v)
    stack = [u]

    while u = stack.pop
      if u.id == v.id
        print u.id
      elsif u.prev == nil
        puts "no path from #{u.id} to #{v.id}"
      else
        print "#{u.id} --➡️  "
      end

      stack.push u.prev
    end
    print "\n"
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

g.vertices.each do |v|
  g.print_path(v, g.vertices[0])
end

