require 'csv'
require 'pp'
require 'pqueue'

module Day17
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      nodes = lines.map { |l| l.chars.map(&:to_i) }
      h = nodes.length
      w = nodes[0].length
      goal = [h-1,w-1]
      start = [0,0]

      min_cost = nil
      fringe = PQueue.new { |a,b| a[:cost] + h(goal, a[:path].last) > b[:cost] + h(goal, b[:path].last) }

      fringe.push({ path: [start], cost: 0})

      visited = Set.new
      furthest = [0,0]

      while !min_cost
        current = fringe.shift
        path = current[:path]
        cost = current[:cost]

        if path.last == goal
          min_cost = cost
          break
        end

        if h(goal, furthest) > h(goal, path.last)
          furthest = path.last
          pp h(goal, path.last)
          pp fringe.size
          puts
        end

        p = 4

        next_nodes(path,h,w).each do |n|
          new_path = path.length >= p ? (path[-p..-1].dup << n) : (path.dup << n)
          new_cost = cost + nodes[n[0]][n[1]]

          if new_path.length < p || visited.add?(new_path[-p..-1])
            fringe.push({path: new_path, cost: new_cost})
          end
        end
      end

      min_cost
    end

    def display(path)
      (0..path.map(&:first).max).each do |y|
        out = ""
        (0..path.map(&:last).max).each do |x|
          out << (path.include?([y,x]) ? "#" : " ")
        end
        puts out
      end
    end

    def h(goal, n)
      goal[0]-n[0] + goal[1]-n[1]
    end

    def next_nodes(path, h, w)
      node = path[-1]
      prev_path = path[0..-2]

      next_nodes = [
        [node[0]+1, node[1]],
        [node[0]-1, node[1]],
        [node[0], node[1]+1],
        [node[0], node[1]-1],
      ]

      # Reject out of bounds
      next_nodes.reject! { |n| n[0] < 0 || n[0] >= h || n[1] < 0 || n[1] >= w }

      # Reject backtracks
      next_nodes.reject! { |n| n == prev_path[-1] }

      # Reject > 3 straight line
      if prev_path.length >= 3
        prev_ys = prev_path[-3..-1].map(&:first)
        prev_xs = prev_path[-3..-1].map(&:last)
        next_nodes.reject! { |n| prev_ys.all? { |y| n[0] == y } || prev_xs.all? { |x| n[1] == x } }
      end

      next_nodes
    end
  end
end
