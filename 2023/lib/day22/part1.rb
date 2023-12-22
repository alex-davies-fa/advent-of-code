require 'csv'
require 'pp'

module Day22
  class Part1
    X = 0; Y = 1; Z = 2
    BOT = 0; TOP = 1

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      bricks = parse_bricks(lines)

      all_supports = {}

      bricks.each_with_index do |brick, i|

        # Drop brick, recording which bricks support it
        while true
          supports = find_supports(brick, bricks[0...i])
          if supports.none? && brick[BOT][Z] > 1
            brick.each { |p| p[Z] = p[Z] - 1 }
          else
            all_supports[brick] = supports
            break
          end
        end
      end

      unsupporting = bricks
      all_supports.values.each do |supps|
        if supps.length == 1 # This is the only brick supporting another brick
          unsupporting.delete(supps.first) # So remove it from the "unsupporting" list
        end
      end

      unsupporting.length
    end

    def find_supports(brick, candidates)
      candidates.filter do |c|
        c[TOP][Z] == brick[BOT][Z] - 1 && overlaps_xy?(brick, c)
      end
    end

    def overlaps_xy?(a,b)
      overlaps?(a.map{_1[X]}, b.map{_1[X]}) && overlaps?(a.map{_1[Y]}, b.map{_1[Y]})
    end

    def overlaps?(a,b)
      a = a.minmax
      b = b.minmax
      return false if (a[1] < b[0] or b[1] < a[0])
      # [a[0], b[0]].max..[a.max, b.max].min
      true
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
