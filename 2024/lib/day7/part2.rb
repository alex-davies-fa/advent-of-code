require 'csv'
require 'pp'

module Day7
  class Part2
    def run(input_file)
      data = read_input(input_file)
      data.sum { |goal, vals| dfs(goal, vals[0], vals[1..]) }
    end

    def dfs(goal, val, rest)
      fringe = [[val, rest]]

      while fringe.any?
        val, rest = fringe.pop

        next if val > goal
        if rest.empty?
          return goal if goal == val
          next
        end

        el = rest.shift
        fringe.push([val+el,rest.dup],[val*el,rest.dup],[pipe(val,el),rest.dup])
      end

      0
    end

    def pipe(a,b)
      (a.to_s + b.to_s).to_i
    end

    def read_input(input_file)
      lines = File.readlines(input_file)
      lines.map do |l|
        goal, vals = l.split(":")
        goal = goal.to_i
        vals = vals.strip.split.map(&:to_i)
        [goal, vals]
      end
    end
  end
end
