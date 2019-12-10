#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './graph.rb'

INF = Float::INFINITY
class Graph
  attr_reader :topological_sorted

  def dfs
    vertices.each do |v|
      v.c = 'w'
      v.prev = nil
    end
    @time = 0
    # used to print topological sorted DAG (Directed aciclyc graphs)
    @topological_sorted = []
    vertices.each do |v|
      dfs_visit(v) if v.c == 'w'
    end
  end

  # topological sorts and print nodes: topological sorted nodes
  # means that if DFS visits (u,v) during his computation than u appears
  # before v thus we print the dependent node after their dependencies.
  def print_topological_sorted
    dfs
    @topological_sorted[0..-2].each do |v|
      print "#{v.id} --➡️  "
    end
    puts @topological_sorted[-1].id
  end

  private

  # recursive version
  def dfs_visit(u)
    @time += 1
    u.d = @time
    u.c = 'g'
    adj[vertices.index(u)].each do |v|
      next unless v.c == 'w'
      v.prev = u
      dfs_visit(v)
    end
    @time += 1
    u.f = @time
    u.c = 'b'
    @topological_sorted.unshift(u)
  end

  # iterative version
  # def dfs_visit(u)
  #   stack = [u]

  #   while u = stack.last
  #     if u.c != 'g'
  #       @time += 1
  #       u.d = @time
  #       u.c = 'g'
  #     end
  #     all_neighbourhods_discovered = true

  #     adj[vertices.index(u)].each do |v|
  #       next unless v.c == 'w'

  #       all_neighbourhods_discovered = false
  #       v.prev = u
  #       stack.push(v)
  #       break
  #     end

  #     if all_neighbourhods_discovered
  #       @time += 1
  #       u.f = @time
  #       u.c = 'b'
  #       stack.pop
  #     end
  #   end
  # end
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
g.print_topological_sorted
