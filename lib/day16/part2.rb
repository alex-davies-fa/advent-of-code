require 'csv'
require 'pp'

module Day16
  class Node
    attr_reader :children, :rate

    def initialize(children, rate)
      @children = children
      @rate = rate
    end

    def sort_children(all_nodes)
      @children = children.sort_by { |n| all_nodes[n].rate }.reverse
    end
  end

  TIME = 30

  class Part2
    def run(input_file)
      nodes = build_nodes(File.readlines(input_file))
      nodes.values.each { _1.sort_children(nodes) }
      @counter = 0
      @max_value = 0

      @state_values = {}

      sorted_nodes = nodes.keys.select { |n| nodes[n].rate > 0 }.sort_by { |n| nodes[n].rate}.reverse
      unopened = Set.new(sorted_nodes)
      pp unopened.map { |n| nodes[n].rate}
      pp dfs(["AA","AA"], nodes, unopened, 4, 0)

      nil
    end

    # Get the maximum possible extra pressure release we can get from this point in time,
    # ignoring all constraints about moving between rooms
    def max_possible(unopened, nodes, time)
      num_to_open = ((TIME - time) / 2.0).ceil * 2
      nodes_to_open =
        unopened.map { |node| nodes[node].rate }.first(num_to_open)

      v = nodes_to_open
        .each_slice(2).each_with_index
        .map { |rates, i| value_of(rates[0], time+1+i*2) + value_of(rates[1] || 0, time+1+i*2) }
        .sum
    end

    def dfs(curr, nodes, unopened, time, value, visited = Set.new, output = [])
      if time == 30
        @counter += 1
        if value > @max_value
          puts "New max: #{value} at c = #{@counter}"
          @max_value = value
          # puts output
          # puts
        end
        # puts "#{@counter}: max = #{@max_value}" if @counter % 100000 == 0
        return value
      end

      return value if unopened.empty?

      max_extra_poss = max_possible(unopened, nodes, time)
      if (max_extra_poss + value) < @max_value
        @counter += 1
        return 0
      end

      # [new_node, valves_to_open, value_add]
      my_moves = []
      if unopened.include?(curr[0])
        my_moves << [curr[0], curr[0], value_of(nodes[curr[0]].rate, time+1)]
      end
      my_moves += nodes[curr[0]].children.map { |child| [child, nil, 0] }

      ele_moves = []
      if unopened.include?(curr[1]) && curr[0] != curr[1] # Elephant doesn't open if both in same room
        ele_moves << [curr[1], curr[1], value_of(nodes[curr[1]].rate, time+1)]
      end
      ele_moves += nodes[curr[1]].children.map { |child| [child, nil, 0] }

      options =
        my_moves.product(ele_moves).map do |my_move, ele_move|
          valves_opened = [my_move[1], ele_move[1]].compact
          new_unopened = valves_opened.any? ? unopened.clone.subtract(valves_opened) : unopened
          new_value = value + my_move[2] + ele_move[2]

          new_state = [time, my_move[0], ele_move[0], new_unopened]
          if @state_values.key?(new_state)
            next if @state_values[new_state] >= new_value
          end
          @state_values[new_state] = new_value
          # pp @state_values

          # Debug
          path = nil
          # my_s = my_move[0] == my_move[1] ? "Open #{my_move[1]} (#{nodes[my_move[1]].rate})" : "Move #{curr[0]} -> #{my_move[0]}"
          # ele_s = ele_move[0] == ele_move[1] ? "Open #{ele_move[1]} (#{nodes[ele_move[1]].rate})" : "Move #{curr[1]} -> #{ele_move[0]}"
          # path = output.clone << "T: #{time}\nMe #{my_s}\nEl #{ele_s}\n\n"

          dfs([my_move[0], ele_move[0]], nodes, new_unopened, time+1, new_value, visited, path)
        end.compact

      options.empty? ? value : options.max
    end

    def value_of(rate, time)
      (TIME-time)*rate
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
