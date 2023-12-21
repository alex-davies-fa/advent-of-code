require 'csv'
require 'pp'

module Day21
  class Part2
    DIRS = [-1,0,1].permutation(2).filter { _1.map(&:abs).sum == 1 }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)

      start, rocks, yr, xr = parse_input(lines)

      fringe = [start]
      visited = Set.new([start])
      burn_in = true

      m = lines.length
      cycles = (0...m).map { [] }

      visited_count = [1,0]

      n = 5000
      n = 26501365

      i = 0
      while burn_in && i <= n
        i += 1

        # Generate all new steps
        new_fringe = Set.new
        fringe.each do |p|
          neighbours(p,rocks,yr,xr).each do |n|
            new_fringe.add(n) if visited.add?(n)
          end
        end

        # All the nodes which appear in the fringe on an even step will re-appear on /every/ future even step
        # So we keep track of a running total of fringe nodes for both odd and even steps
        visited_count[i % 2] = visited_count[i % 2] + new_fringe.length

        fringe = new_fringe

        # With no obstacles, we'd see 4*i nodes in the fringe at step i
        # However, the obstacles will perturb this value, but in a regular way due to the repeating pattern
        # Keep track of the difference between the "simple" value and what we actually see, for each modulo of the
        # grid size
        cycles[i%m] << 4*i - fringe.length

        # Check if all cycles have burned in, and stop the manually stepping once they have
        burn_in = false if cycles.all? { |d| d.length >= 3 && (d[-1] - d[-2]) == (d[-2] - d[-3]) }
      end


      # Now fill in the rest of the cycles based on known pattern of nodes in each fringe
      # (We could do this faster by doing some maths instead of iterating, but this works quickly enough...)
      cycle_starts = cycles.map(&:last)
      cycle_steps = cycles.map { |c| c[-1] - c[-2] }
      (i+1..n).each do |c|
        ind = c % m
        offset = (c-i-1) / m + 1
        a = cycle_starts[ind] + offset * cycle_steps[ind]
        visited_count[c % 2] = visited_count[c % 2] + 4*c - a
      end

      # Return the odd or even value
      visited_count[n % 2]
    end

    def neighbours(p,rocks,yr,xr)
      ns = DIRS.map { add(_1,p) }
      ns.filter { |y,x| !rocks.include?([y % yr.end,x % xr.end]) }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def parse_input(lines)
      rocks = Set.new
      start = nil

      lines.each_with_index do |l, y|
        l.split("").each_with_index do |c, x|
          if c == "#"
            rocks.add([y,x])
          elsif c == "S"
            start = [y,x]
          end
        end
      end

      [start, rocks, (0...lines.length), (0...lines[0].length)]
    end
  end
end
