require 'csv'
require 'pp'

module Day9
  class Part1

    def run(input_file)
      ps = File.readlines(input_file).map { |l| l.split(",").map(&:to_i) }

      ps.combination(2).map { size(_1, _2) }.max
    end

    def size(p1,p2)
      ((p1[0]-p2[0]).abs + 1) * ((p1[1]-p2[1]).abs + 1)
    end
  end
end
