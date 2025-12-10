require 'csv'
require 'pp'

module Day10
  class Part2
    def run(input_file)
      lines = File.readlines(input_file).map { |l| l.chomp.split(" ") }
      machines = lines.map do |l|
        buttons = l[1..-2].map { _1[1..-2].split(",").map(&:to_i) }
        buttons = buttons.sort_by { _1.length }
        joltages = l[-1][1..-2].split(",").map(&:to_i)
        
        { buttons: , joltages: }
      end

      machines.sum do |machine|
        val = shortest_seq(machine)
        pp val
        val
      end
    end

    def shortest_seq(machine)
      target = machine[:joltages]
      start_state = [0] * target.length
      fringe = [ [start_state, Hash.new(0)] ]
      visited = Set.new([start_state, Hash.new(0)])
      best_solution = 999999999999

      while state = fringe.shift
        joltages, actions = state
        if joltages == target && actions.values.sum < best_solution
          best_solution = actions.values.sum
          puts " - " + best_solution.to_s
        end

        machine[:buttons].each do |button|
          new_joltages = next_state(joltages,button)
          new_actions = actions.dup
          new_actions[button] += 1
          new_action_count = new_actions.values.sum

          diffs = new_joltages.zip(target).map { _2 - _1 }
          next if diffs.any? { _1 < 0 }
          min_possible_steps = diffs.max
          next if new_action_count + min_possible_steps > best_solution
          
          next if visited.include?([new_joltages,new_actions])

          # pp new_action_count

          visited.add([new_joltages,new_actions])
          fringe.unshift([new_joltages,new_actions])
        end
      end

      best_solution
    end

    def next_state(joltages,button)
      joltages = joltages.dup
      button.each { |i| joltages[i] += 1 }
      joltages
    end
  end
end
