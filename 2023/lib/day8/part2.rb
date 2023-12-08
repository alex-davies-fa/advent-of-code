require 'csv'
require 'pp'

module Day8
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      dirs = lines[0].split('').map { _1 == 'L' ? 0 : 1 }
      nodes = lines[2..].map do |line|
        node, left, right = line.scan(/[A-Z0-9]+/)
        [node, [left, right]]
      end.to_h

      start_nodes = nodes.keys.select { _1.end_with?("A") }
      steps = 0

      cycles = []

      start_nodes.each_with_index do |node, cycle_i|
        steps = 0
        states = []
        state_set = Set.new
        while true
          dirs.each_with_index do |d, d_i|
            steps += 1
            node = nodes[node][d]
            states << [node, d_i, steps]
            novel_state = state_set.add?([node, d_i])
            if !novel_state && node.end_with?("Z")
              cycles[cycle_i] = states
              break
            end
          end
          break if cycles[cycle_i]
        end
      end

      # Get offset and length of each cycle
      cycle_stats = cycles.map do |cycle|
        end_node, end_dir, _ = cycle[-1]
        start_index = cycle.find_index { _1[0] == end_node && _1[1] == end_dir }
        [start_index + 1, cycle.length - start_index - 1]
      end

      # Looks like cycles all repeat with no burn in, so can just use the cycle length, no need to worry
      # about offsets!
      cycle_stats.map(&:first).reduce(1, :lcm)
    end
  end
end
