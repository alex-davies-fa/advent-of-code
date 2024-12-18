require 'csv'
require 'pp'
require 'pqueue'

module Day18
  class Part2
    S = 71
    # S = 7
    DIRS = [[0,1], [1,0], [0,-1], [-1,0]]

    def run(input_file)
      lines = File.readlines(input_file)
      bytes = lines.map { _1.split(",").map(&:to_i) }
      
      n = 1024 # Really oughtta binary search but this is quick enough
      while exit_reachable?(n, bytes)
        n += 1
      end

      bytes[n-1]
    end

    def exit_reachable?(n, all_bytes)
      map = Set.new(all_bytes.first(n))

      p = [0,0]
      g = [S-1,S-1]

      queue = PQueue.new([[p,0]]) { _1[1] < _2[1] }
      dists = {}
      dists[[0,0]] = 0

      while s = queue.pop
        p, cost = s
        break if p == g

        nps = DIRS.map { |d| add(d,p) }.reject { map.include?(_1) || out_of_bounds?(_1) }
        nps.each do |np|
          if !dists.include?(np) || cost + 1 < dists[np]
            dists[np] = cost + 1
            queue.push([np,cost+1])
          end
        end
      end

      p == g
    end

    def add(a,b)
      [a[0] + b[0], a[1] + b[1]]
    end

    def out_of_bounds?(p)
      p[0] < 0 || p[0] >= S || p[1] < 0 || p[1] >= S
    end
  end
end
