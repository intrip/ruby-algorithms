#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './graph.rb'

INF = Float::INFINITY
class Graph
  def dfs
    vertices.each do |v|
      v.c = 'w'
      v.prev = nil
    end
    @time = 0
    vertices.each do |v|
      dfs_visit(v) if v.c == 'w'
    end
  end

  private

  # recursive version
  # def dfs_visit(u)
  #   @time += 1
  #   u.d = @time
  #   u.c = 'g'
  #   adj[vertices.index(u)].each do |v|
  #     next unless v.c == 'w'
  #     v.prev = u
  #     dfs_visit(v)
  #   end
  #   @time += 1
  #   u.f = @time
  #   u.c = 'b'
  # end

  # iterative version
  def dfs_visit(u)
    stack = [u]

    while u = stack.last
      if u.c != 'g'
        @time += 1
        u.d = @time
        u.c = 'g'
      end
      all_neighbourhods_discovered = true

      adj[vertices.index(u)].each do |v|
        next unless v.c == 'w'

        all_neighbourhods_discovered = false
        v.prev = u
        stack.push(v)
        break
      end

      if all_neighbourhods_discovered
        @time += 1
        u.f = @time
        u.c = 'b'
        stack.pop
      end
    end
  end
end

class Vertex
  COLORS = %w(w b g)
  attr_reader :id
  attr_accessor :c, :d, :f, :prev

  def initialize(id)
    @id = id
  end

  def inspect
    "#{id}@#{d}##{f}".then { |s| prev ? s + "<#{prev.id}" : s }
  end
end

g = build_graph
g.dfs
g.vertices.each do |v|
  p v
end
# TODO
# DAG topological sort
