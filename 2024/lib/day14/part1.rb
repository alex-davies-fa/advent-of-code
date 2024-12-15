require 'csv'
require 'pp'

module Day14
  class Part1
    W = 101
    H = 103

    def run(input_file)
      robots = read_robots(input_file)

      end_pos = robots.map do |p,v|
        x = (p[0]+100*v[0]) % W
        y = (p[1]+100*v[1]) % H

        [x,y]
      end

      qs = end_pos
        .filter { |x,y| x != (W-1)/2 && y != (H-1)/2 }
        .map { |x,y| [x < W/2.0, y < H/2.0] }

      qs.tally.values.inject(:*)
    end

    def read_robots(input_file)
      File.readlines(input_file).map do |l|
        ps, vs = l.split(" ")
        p = ps.split("=")[1].split(",").map(&:to_i)
        v = vs.split("=")[1].split(",").map(&:to_i)
        [p,v]
      end
    end
  end
end
