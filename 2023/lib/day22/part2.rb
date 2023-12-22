require 'csv'
require 'pp'

module Day22
  class Part2
    X = 0; Y = 1; Z = 2
    BOT = 0; TOP = 1

    Brick = Struct.new("Brick", :above, :below) do
      def clone
        Brick.new(above.dup, below.dup)
      end
    end

    graph = {}

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      bricks = parse_bricks(lines)
      graph = drop_bricks(bricks)
      graph.keys.sum { |b| count_dropped(graph, b) }
    end

    def count_dropped(graph_orig, b)
      graph = {}
      graph_orig.each { |k,v| graph[k] = v.clone }

      to_drop = [b]
      dropped = 0

      while i = to_drop.shift
        # Iterate over each brick /above/ the dropped brick, removing the dropped brick from the list of
        # bricks below it, and adding it to the list to destroy IF it has no remaining bricks below
        graph[i].above.each do |j|
          graph[j].below.delete(i)
          if graph[j].below.empty?
            to_drop.append(j)
            dropped += 1
          end
        end
      end

      dropped
    end

    # Drops all bricks to their resting positions, and returns a data structure representing which bricks
    # sit above / below each brick, in the form:
    # {
    #   0 => Brick(above: [1,2,3], below: [4,5]),
    #   ...
    # }
    def drop_bricks(bricks)
      graph = Hash.new { |h,k| h[k] = {} }

      bricks.each_with_index do |brick, i|
        while true
          supports = find_supports(brick, bricks[0...i])
          if supports.none? && brick[BOT][Z] > 1
            # Optimisation - instead of dropping one step, drop directly to above the next lowest brick
            new_bot = (bricks[0...i].map{_1[TOP][Z]}.filter{ _1 < brick[BOT][Z] - 1}.max || 0 ) + 1
            z_diff = new_bot - brick[BOT][Z]
            brick.each { |p| p[Z] = p[Z] + z_diff }
          else
            graph[i] = graph[i] = Brick.new([],supports)
            supports.each { |s| graph[s].above << i }
            break
          end
        end
      end

      graph
    end

    def find_supports(brick, candidates)
      candidates.each_with_index.filter do |c,i|
        c[TOP][Z] == brick[BOT][Z] - 1 && overlaps_xy?(brick, c)
      end.map(&:last)
    end

    def overlaps_xy?(a,b)
      overlaps?(a.map{_1[X]}, b.map{_1[X]}) && overlaps?(a.map{_1[Y]}, b.map{_1[Y]})
    end

    def overlaps?(a,b)
      a = a.minmax
      b = b.minmax
      !(a[1] < b[0] or b[1] < a[0])
    end

    # Returns bricks in order from "lowest" to "highest",
    # With bricks [p1,p2] s.t. p1_z <= p2_z
    def parse_bricks(lines)
      lines.map do |l|
        x1,y1,z1,x2,y2,z2 = l.scan(/[0-9]+/).map(&:to_i)
        [[x1,y1,z1],[x2,y2,z2]].sort_by { _1[Z] }
      end.sort_by { _1[BOT][Z] }
    end
  end
end
