require 'csv'
require 'pp'

module Day23
  class Part2
    DIRS = [[0,1],[0,-1],[-1,0],[1,0]]

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)

      graph = build_graph(lines)

      start = [0,1]
      terminal = [lines.length-1, lines[0].length-2]

      longest_path(start,terminal,graph)
    end

    def longest_path(current, terminal, graph, length = 0, visited = Set.new)
      return length if current == terminal

      edges = graph[current].filter { !visited.include?(_1[:node]) }
      return 0 if edges.empty?
      new_visited = visited.dup.add(current)

      edges.map do |edge|
        longest_path(edge[:node], terminal, graph, length+edge[:cost], new_visited)
      end.max
    end

    def build_graph(lines)
      spaces = Set.new

      lines.each_with_index do |l, y|
        l.chars.each_with_index do |c, x|
          spaces.add([y,x]) if c != "#"
        end
      end

      graph = {}

      start = [0,1]
      fringe = [start]

      while fringe.any?
        p = fringe.shift
        path_start = p
        spaces.delete(p)
        adj = DIRS.map { |d| add(p,d) if spaces.include?(add(p,d)) }.compact
        length = 1
        while adj.length == 1
          p = adj[0]
          spaces.delete(p)
          adj = DIRS.map { |d| add(p,d) if spaces.include?(add(p,d)) }.compact
          length += 1
        end
        fringe = fringe + adj
        path_end = p
        graph[path_start] = [{ node: path_end, cost: length-1 }]
        graph[path_end] = adj.map { |a| { node: a, cost: 1 } }
      end

      full_graph = Hash.new { |h,k| h[k] = [] }

      graph.each do |source, dests|
        full_graph[source] = full_graph[source] + dests
        dests.each { |d| full_graph[d[:node]] << { node: source, cost: d[:cost] } }
      end

      full_graph
    end

    def add(a,b)
      [a[0] + b[0], a[1] + b[1]]
    end
  end
end
