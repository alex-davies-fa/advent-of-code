require 'csv'
require 'pp'

module Day25
  class Part1
    C = [1]

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)

      graph = Hash.new { |h,k| h[k] = [] }
      lines.each do |l|
        a, *bs = l.scan(/[a-z]+/)
        bs.each { |b| graph[a] << b; graph[b] << a}
      end

      graph_orig = graph

      # 1.times do
      while true
        graph = Hash.new { |h,k| h[k] = [] }
        graph_orig.each { |k,v| graph[k] = v.dup }
        while graph.length > 30
          contract(graph)
          # puts
        end
        # pp graph
        graph.each { |a,bs| puts "#{a} -- {#{bs.join(" ")}}" }

        partition_sizes = graph.keys.map { |k| k.start_with?("NN") ? k.split("_").last.to_i : 1 }
        pp partition_sizes
      end

      nil
    end

    def contract(graph)
      edge = graph.flat_map { |k,v| v.map { |v| [k,v] } }.sample
      n1,n2 = edge
      new_node = "#{n1}:#{n2}"
      c1 = n1.start_with?("NN") ? n1.split("_").last.to_i : 1
      c2 = n2.start_with?("NN") ? n2.split("_").last.to_i : 1

      new_node = "NN_#{C.last}_#{c1+c2}"
      C[0] = C[0] + 1

      [n1,n2].each do |n|
        graph[n].each do |v|
          next if [n1, n2].include?(v)
          graph[new_node] << v
          graph[v] << new_node
          graph[v].delete(n)
        end
        graph.delete(n)
      end

      graph
    end
  end
end
