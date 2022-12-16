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

  Move = Struct.new(:dest, :valve_opened, :value)

  TIME = 30

  class Part2
    def run(input_file)
      nodes = build_nodes(File.readlines(input_file))

      # Optimisation (maybe?) - order all children by highest rate, so we'll preferentially visit the highest rate first
      nodes.values.each { _1.sort_children(nodes) }

      # Presort the our set of unopened nodes so we don't have to do it all the time
      # (Not sure that set actually gaurantees the order you get back, but hey)
      sorted_nodes = nodes.keys.select { |n| nodes[n].rate > 0 }.sort_by { |n| nodes[n].rate}.reverse
      unopened = Set.new(sorted_nodes)

      # Global state to store
      # - Best current 30 min pressure release
      # - Best pressure release for all visited states (i.e. time / position / valve opened tuples)
      @max_value = 0
      @state_values = {}

      pp dfs("AA","AA", nodes, unopened, 4, 0)

      nil
    end

    # Get the maximum possible extra pressure release we can get from this point in time,
    # ignoring all constraints about moving between rooms
    # i.e. pick the 8 highest closed valves, and open over the next 4 steps
    def max_possible(unopened, nodes, time)
      num_to_open = ((TIME - time) / 2.0).ceil * 2
      nodes_to_open =
        unopened.map { |node| nodes[node].rate }.first(num_to_open)

      v = nodes_to_open
        .each_slice(2).each_with_index
        .map { |rates, i| value_of(rates[0], time+1+i*2) + value_of(rates[1] || 0, time+1+i*2) }
        .sum
    end

    def dfs(my_pos, ele_pos, nodes, unopened, time, value, visited = Set.new)
      # We've hit 30 mins - store this as the best value if it is
      if time == TIME
        if value > @max_value
          puts "New max: #{value}"
          @max_value = value
        end
        return value
      end

      # The maximum possible extra value we could get from this point is lower than our current best path,
      # so bail out of this path
      return 0 if (max_possible(unopened, nodes, time) + value) < @max_value

      # All my possible moves - open a valve if we're at an unopened one, or visit a child
      my_moves = []
      my_moves << Move.new(my_pos, my_pos, value_of(nodes[my_pos].rate, time+1)) if unopened.include?(my_pos)
      my_moves += nodes[my_pos].children.map { |child| Move.new(child, nil, 0) }

      # All elephant possible moves - open a valve if we're at an unopened one, or visit a child
      ele_moves = []
      if unopened.include?(ele_pos) && my_pos != ele_pos # Elephant doesn't open if both in same room
        ele_moves << Move.new(ele_pos, ele_pos, value_of(nodes[ele_pos].rate, time+1))
      end
      ele_moves += nodes[ele_pos].children.map { |child| Move.new(child, nil, 0) }

      # Take the product of all our moves and all elephant moves, and continue DFS on each pair
      options =
        my_moves.product(ele_moves).map do |my_move, ele_move|
          valves_opened = [my_move.valve_opened, ele_move.valve_opened].compact
          new_unopened = valves_opened.any? ? unopened.clone.subtract(valves_opened) : unopened
          new_value = value + my_move.value + ele_move.value

          # Optimisation to prevent revisiting positions
          # Check current state (time, positions, valves opened)
          # If we've seen it before with at least as good value, bail on this path
          # Otherwise record this state
          new_state = [time, my_move.dest, ele_move.dest, new_unopened]
          next if @state_values[new_state] >= new_value if @state_values.key?(new_state)
          @state_values[new_state] = new_value

          # Continue DFS from this position
          dfs(my_move.dest, ele_move.dest, nodes, new_unopened, time+1, new_value, visited)
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
