require 'csv'
require 'pp'

module Day16
  class Node
    attr_reader :children, :rate

    def initialize(children, rate)
      @children = children
      @rate = rate
    end
  end

  TIME = 30

  class Part1
    def run(input_file)
      nodes = build_nodes(File.readlines(input_file))

      @counter = 0
      @max_value = 0

      unopened = Set.new(nodes.keys.select { |n| nodes[n].rate > 0 })
      pp dfs(nodes.first[0], nodes, unopened, 0, 0)

      nil
    end

    # Get the maximum possible extra pressure release we can get from this point in time,
    # ignoring all constraints about moving between rooms
    def max_possible(unopened, nodes, time)
      num_to_open = ((TIME - time) / 2.0).ceil
      nodes_to_open =
        unopened.map { |node| nodes[node].rate }
          .sort.reverse.first(num_to_open)

      v = nodes_to_open.each_with_index.map { |rate, i| value_of(rate, time+1+i*2) }.sum
    end

    def dfs(curr, nodes, unopened, time, value, path=[])
      if time == TIME
        @counter += 1
        if value > @max_value
          puts "New max: #{value} at time = #{time}"
          pp path
          @max_value = value
        end
        puts "#{@counter}: max = #{@max_value}" if @counter % 10000 == 0
        return value
      end

      options = []

      max_extra_poss = max_possible(unopened, nodes, time)
      if (max_extra_poss + value) < @max_value
        @counter += 1
        return 0
      end

      if unopened.include?(curr)
        new_unopened = unopened.clone.delete(curr)
        total_release = value_of(nodes[curr].rate, time+1)
        options << dfs(curr, nodes, new_unopened, time+1, value + total_release, path.clone << "Open #{curr}, value: #{value + total_release}")
      end

      options += nodes[curr].children.map do |child|
        dfs(child, nodes, unopened, time+1, value, path.clone << "Move #{child}, value: #{value}")
      end

      options.max
    end

    def value_of(rate, time)
      (30-time)*rate
    end

    def build_nodes(lines)
      lines.map do |line|
        words = line.split
        name = words[1]
        /rate=(?<rate>\d+);/ =~ words[4]
        children = words[9..-1].map { |w| w[0..1] }
        [name, Node.new(children, rate.to_i)]
      end
        .to_h
    end
  end
end
