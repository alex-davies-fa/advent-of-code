require 'csv'
require 'pp'
require 'pqueue'

module Day17
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      nodes = lines.map { |l| l.chars.map(&:to_i) }

      h = nodes.length
      w = nodes[0].length
      goal = [h-1,w-1]

      min_cost = nil

      # Fringe stored as [node, direction, distance, cost]
      fringe = PQueue.new { |a,b| a[3] + h(goal, a[0]) > b[3] + h(goal, b[0]) }
      fringe.push([[1,0], [1,0], 1, nodes[1][0]])
      fringe.push([[0,1], [0,1], 1, nodes[0][1]])

      visited = Set.new

      while !min_cost
        node, dir, dist, cost = fringe.shift

        if node == goal && dist >= 4
          min_cost = cost
          break
        end

        next_nodes(node,dir,dist,h,w).each do |new_node, new_dir, new_dist|
          new_cost = cost + nodes[new_node[0]][new_node[1]]

          if visited.add?([new_node, new_dir, new_dist])
            fringe.push([new_node, new_dir, new_dist, new_cost])
          end
        end
      end

      min_cost
    end

    def h(goal, n)
      goal[0]-n[0] + goal[1]-n[1]
    end

    def next_nodes(node,dir,dist, h, w)
      all_dirs = [
        [1,0],
        [-1,0],
        [0,1],
        [0,-1],
      ]

      next_dirs = nil
      if dist < 4
        next_dirs = [dir] # Have to continue
      elsif dist == 10
        next_dirs = all_dirs - [dir, dir.map{-1*_1}] # Can't go back or forward
      else
        next_dirs = all_dirs - [dir.map{-1*_1}] # Can't go back
      end

      next_dirs.map do |next_dir|
        next_node = [node[0]+next_dir[0], node[1]+next_dir[1]]
        next if next_node[0] < 0 || next_node[0] >= h || next_node[1] < 0 || next_node[1] >= w
        next_dist = next_dir == dir ? dist + 1 : 1

        [next_node, next_dir, next_dist]
      end.compact
    end
  end
end
