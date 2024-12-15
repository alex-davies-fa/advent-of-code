require 'csv'
require 'pp'

module Day14
  class Part2
    W = 101
    H = 103

    T = 1
    def run(input_file)
      robots = read_robots(input_file)

      t = T

      lengths = []
      while t < 10000
        ps = robots.map do |p,v|
          x = (p[0]+t*v[0]) % W
          y = (p[1]+t*v[1]) % H

          [x,y]
        end

        lengths << Set.new(ps).length
        if Set.new(ps).length == 500
          pp t
          display(ps)
          break
        end
        t += 1
      end

      # pp lengths.tally.sort_by { |k,v| k }

      nil
    end

    def display(ps)
      ps = Set.new(ps)
      (0...H).each do |y|
        l = ""
        (0...W).each do |x|
          l += ps.include?([x,y]) ? "🟩" : "⬛️"
        end
        puts l
      end
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
