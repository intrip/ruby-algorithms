# You are given a matrix which contains many points.
# Each point has a color and you need yo find the amount of the biggest connected area with the same
# color.
# For example:
#
# [
#   [ 'r', 'r', 'r', 'b', 'o'],
#   [ 'r', 'b', 'b', 'b', 'o'],
#   [ 'r', 'b',  o',  o', 'b'],
#   [ 'r', 'o', 'b', 'b', 'b']
# ]
# returns 6 which is the red area
#
#

def biggest_conn_area_dfs(m)
  biggest_conn_area(m, 'dfs')
end

def biggest_conn_area_bfs(m)
  biggest_conn_area(m, 'bfs')
end

def biggest_conn_area(m, type)
  ans = 0
  return ans if m.length == 0 || m[0].length == 0

  visited = Array.new(m.size) { Array.new(m[0].size, false) }

  m.length.times do |i|
    m[0].length.times do |j|
      if type == 'dfs'
        ans = [ans, dfs_visit(m, i, j, visited)].max unless visited[i][j]
      else
        ans = [ans, bfs_visit(m, i, j, visited)].max unless visited[i][j]
      end
    end
  end

  ans
end

def dfs_visit(m, i, j, visited, size = 1)
  visited[i][j] = true

  [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |offset|
    r = i + offset[0]
    c = j + offset[1]

    next if r < 0 || r >= m.length
    next if c < 0 || c >= m[0].length
    next if m[i][j] != m[r][c]
    next if visited[r][c]
    size = dfs_visit(m, r, c, visited, size + 1)
  end

  size
end

def bfs_visit(m, i, j, visited)
  size = 0
  stack = [[i,j]]

  while node = stack.pop
    i, j = node
    size += 1
    visited[i][j] = true

    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |offset|
      r = i + offset[0]
      c = j + offset[1]

      next if r < 0 || r >= m.length
      next if c < 0 || c >= m[0].length
      next if m[i][j] != m[r][c]
      next if visited[r][c]

      stack << [r,c]
    end
  end

  size
end

a = [
  [ 'r', 'r', 'r', 'b', 'o'],
  [ 'r', 'b', 'b', 'b', 'o'],
  [ 'r', 'b', 'o', 'o', 'b'],
  [ 'r', 'o', 'b', 'b', 'b']
]

p biggest_conn_area_dfs(a)
# => 6
p biggest_conn_area_bfs(a)
# => 6
