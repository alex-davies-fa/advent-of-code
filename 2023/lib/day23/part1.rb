require 'csv'
require 'pp'

module Day23
  class Part1
    SLOPES = {
      ">" => [0,1],
      "<" => [0,-1],
      "^" => [-1,0],
      "v" => [1,0],
    }

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

      next_nodes = graph[current].filter { !visited.include?(_1) }
      return 0 if next_nodes.empty?
      new_visited = visited.dup.add(current)

      next_nodes.map do |node|
        longest_path(node, terminal, graph, length+1, new_visited)
      end.max
    end

    def build_graph(lines)
      spaces = Set.new
      slopes = Set.new

      lines.each_with_index do |l, y|
        l.chars.each_with_index do |c, x|
          case c
          when "."
            spaces.add([y,x])
          when *SLOPES.keys
            slopes.add([y,x,SLOPES[c]])
          end
        end
      end

      graph = {}

      slope_points = slopes.map{ _1[0..1]}
      spaces.each do |p|
        adj = DIRS.map do |d|
          np = add(p,d)
          np if spaces.include?(np) || slope_points.include?(np)
        end.compact
        graph[p] = adj
      end

      slopes.each do |y,x,d|
        graph[[y,x]] = [add([y,x],d)] # All slopes in input have a space at top and bottom
      end

      graph
    end

    def add(a,b)
      [a[0] + b[0], a[1] + b[1]]
    end
  end
end
