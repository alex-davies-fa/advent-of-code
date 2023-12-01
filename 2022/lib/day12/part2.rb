require 'csv'
require 'pp'
require 'matrix'
require 'gastar'

module Day12
  class Node
    attr_reader :height, :neighbours, :name

    def initialize(height, name = "Node")
      @height = height
      @name = name
    end

    def to_s
      "#{name} (#{height})"
    end

    def set_neighbours(neighbours)
      @neighbours = neighbours
    end
  end

  class Part2
    def run(input_file)
      map = File.readlines(input_file).map(&:strip).map(&:chars)
      start_index = Matrix[*map].find_index('S')
      end_index = Matrix[*map].find_index('E')
      map[start_index[0]][start_index[1]] = 'a'
      map[end_index[0]][end_index[1]] = 'z'

      nodes = build_nodes(map)

      possible_starts = []
      Matrix[*map].each_with_index do |c, y, x|
        possible_starts << nodes[Vector[y,x]] if c == 'a'
      end

      paths = possible_starts.map { |start| shortest_path(nodes, start, nodes[Vector[*end_index]]) }
      puts (paths.compact.map(&:length).min - 1)

      nil
    end

    def shortest_path(nodes, s, e)
      queue = Queue.new
      queue.enq(s)
      paths = { s => nil }

      while !queue.empty?
        curr = queue.deq
        return build_path(paths, e) if curr == e

        curr.neighbours.each do |n|
          next if paths.key?(n) # Don't revisit a node
          paths[n] = curr
          queue.enq(n)
        end
      end

      nil
    end

    def build_path(paths, e)
      path = []
      tail = e
      while tail
        path << tail
        tail = paths[tail]
      end

      path.reverse
    end

    def build_nodes(map)
      width = map.first.length
      height = map.length

      nodes = {}

      (0...height).each do |y|
        (0...width).each do |x|
          nodes[Vector[y,x]] = Node.new(get_height(map[y][x]), "[#{y},#{x}]")
        end
      end

      nodes.each { |pos, node| set_neighbours!(pos, node, nodes) }

      nodes
    end

    def set_neighbours!(pos, node, nodes)
      offsets = [Vector[-1,0], Vector[1,0], Vector[0,-1], Vector[0,1]]
      neighbours = offsets
        .map { |o| o + pos }
        .map { |p| nodes[p] }
        .compact
        .reject { |n| n.height > node.height + 1 }

      node.set_neighbours(neighbours)
    end

    def get_height(char)
      char.ord - 'a'.ord
    end
  end
end
