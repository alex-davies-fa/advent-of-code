require 'csv'
require 'pp'

module Day25
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)

      graph = Hash.new { |h,k| h[k] = [] }
      lines.each do |l|
        a, *bs = l.scan(/[a-z]+/)
        bs.each { |b| graph[a] << b; graph[b] << a }
      end

      # graph.each { |a,bs| puts "#{a} -- {#{bs.join(" ")}}" }

      nodes = (graph.keys + graph.values.inject(&:+)).uniq

      n = nodes.first
      edge_fringe = graph[n].map { |d| [n,d] }
      partitions = { n => 0 }

      pp search(edge_fringe, graph, partitions)
      nil
    end

    def search(edge_fringe, graph, partitions, visited = Set.new, bridges = [])
      if edge_fringe.empty?
        if bridges.length == 3
          return bridges
        else
          return nil
        end
      end

      edge_fringe = edge_fringe.map(&:dup)
      bridges = bridges.dup
      partitions = partitions.dup
      visited = visited.dup

      edge = edge_fringe.shift

      v1 = visited.add?(edge)
      v2 = visited.add?(edge.reverse)
      return search(edge_fringe, graph, partitions, visited, bridges) if (!v1 || !v2)

      n1,n2 = edge

      if !partitions[n1]
        puts "NO PARTITION FOR START NODE"
        exit(0)
      end

      if partitions[n2]
        if partitions[n1] == partitions[n2]
          # Edge connects two nodes in the same partition, nothing to add
          return search(edge_fringe, graph, partitions, visited, bridges)
        elsif partitions[n1] != partitions[n2]
          # Nodes are in different partitions, edge must be a bridge
          return nil if bridges.length == 3
          return search(edge_fringe, graph, partitions, visited, bridges + [edge])
        end
      else
        # Try both options for partitioning end of edge node
        # - Not switching partition
        edge_fringe_1 = edge_fringe.map(&:dup)
        edge_fringe_1 = edge_fringe_1 + graph[n2].filter_map { |d| [n2,d] unless d == n1 }
        partitions_1 = partitions.dup
        partitions_1[n2] = partitions[n1]
        bridges_1 = bridges.dup
        result_1 = search(edge_fringe_1, graph, partitions_1, visited, bridges_1)

        # - Switching partition
        result_2 = nil
        if bridges.length < 3
          edge_fringe_2 = edge_fringe.map(&:dup)
          edge_fringe_2 = edge_fringe_2 + graph[n2].filter_map { |d| [n2,d] unless d == n1 }
          partitions_2 = partitions.dup
          partitions_2[n2] = 1 - partitions[n1]
          bridges_2 = bridges.dup
          bridges_2 << [edge]
          result_2 = search(edge_fringe_2, graph, partitions_2, visited, bridges_2)
        end

        return result_1 || result_2
      end
    end
  end
end
